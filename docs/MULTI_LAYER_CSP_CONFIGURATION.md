# Multi-Layer Content Security Policy Configuration Guide

## Overview

This guide provides instructions for configuring Content Security Policy (CSP) headers at multiple layers of your infrastructure for defense-in-depth security.

**Current Implementation Status:**
- ✅ **Application Layer (Laravel)**: Already configured via Spatie CSP middleware
- ✅ **Web Server Layer (Apache)**: Configuration added to `.htaccess`
- 📋 **Nginx Layer**: Configuration example provided below
- 📋 **Load Balancer Layer**: Configuration examples provided below

---

## Layer 1: Application Level (Laravel) - ALREADY CONFIGURED ✅

Your Laravel application already has CSP configured via middleware.

**Location:** `app/Http/Kernel.php:42`

```php
protected $middlewareGroups = [
    'web' => [
        // ...
        \Spatie\Csp\AddCspHeaders::class, // ✅ Active
    ],
];
```

**Configuration:** `config/csp.php`
**Custom Policy:** `app/Services/Csp/Policies/MyCustomPolicy.php`

**Status:** ✅ This is working and setting CSP headers on all responses.

---

## Layer 2: Web Server Level

### Option A: Apache (.htaccess) - CONFIGURED ✅

**Location:** `public/.htaccess`

I've added security headers to your `.htaccess` file. The CSP header is currently **commented out** by default to avoid duplication with your Laravel middleware.

**To activate server-level CSP (optional):**

Edit `public/.htaccess` and uncomment line 30:

```apache
<IfModule mod_headers.c>
    # Uncomment the line below to enable server-level CSP
    Header always set Content-Security-Policy "default-src 'self'; script-src 'self' ..."
</IfModule>
```

**Note:** The `.htaccess` file now includes these additional security headers (active by default):
- `X-Content-Type-Options`
- `X-Frame-Options`
- `X-XSS-Protection`
- `Referrer-Policy`
- `Permissions-Policy`

### Option B: Nginx Configuration

If you're using Nginx instead of Apache, add this to your server block configuration:

**File:** `/etc/nginx/sites-available/your-app` (or equivalent)

```nginx
server {
    listen 80;
    server_name app.datatoolspro.com;
    root /path/to/your-app/public;

    index index.php;

    # Security Headers
    add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' c.salesforce.com cdn.pendo.io https://js-agent.newrelic.com https://salesiq.zohopublic.com *.zohocdn.com kit.fontawesome.com code.jquery.com cdn.jsdelivr.net cdn.heapanalytics.com https://buttons-config.sharethis.com https://platform-api.sharethis.com buttons.github.io cdnjs.cloudflare.com unpkg.com app.pendo.io; style-src 'self' 'unsafe-inline' c.salesforce.com *.zohocdn.com data.pendo.io fonts.googleapis.com cdn.jsdelivr.net cdn.datatables.net cdnjs.cloudflare.com; connect-src 'self' c.salesforce.com https://bam.nr-data.net wss://vts.zohopublic.com https://salesiq.zohopublic.com/ ka-f.fontawesome.com https://fuse.flatirons.com api.github.com datatoolspro.com https://l.sharethis.com data.pendo.io app.pendo.io; img-src 'self' data: *.zohocdn.com https://salesiq.zohopublic.com https://platform-cdn.sharethis.com cdn.pendo.io app.pendo.io datatoolspro.com https://l.sharethis.com www.w3.org heapanalytics.com cdn.datatables.net; frame-src 'self' youtube.com www.youtube.com app.pendo.io datatoolspro.com; form-action 'self' *.stripe.com login.salesforce.com test.salesforce.com salesforce.com *.salesforce.com; frame-ancestors 'self' app.pendo.io; worker-src 'self' blob:;" always;

    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
```

**After making changes, reload Nginx:**
```bash
sudo nginx -t  # Test configuration
sudo systemctl reload nginx
```

---

## Layer 3: Load Balancer Level

### AWS Application Load Balancer (ALB)

**Option 1: Using Response Headers Policy (Recommended)**

1. Go to AWS Console → EC2 → Load Balancers
2. Select your ALB
3. Go to "Listeners" tab
4. Edit your listener rules
5. Add "Insert header" action:
   - **Header name:** `Content-Security-Policy`
   - **Header value:** Your CSP policy string

**Option 2: Using Lambda@Edge (CloudFront)**

Create a Lambda function to add headers:

```javascript
exports.handler = async (event) => {
    const response = event.Records[0].cf.response;
    const headers = response.headers;

    headers['content-security-policy'] = [{
        key: 'Content-Security-Policy',
        value: "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' c.salesforce.com cdn.pendo.io ..."
    }];

    headers['x-content-type-options'] = [{
        key: 'X-Content-Type-Options',
        value: 'nosniff'
    }];

    headers['x-frame-options'] = [{
        key: 'X-Frame-Options',
        value: 'SAMEORIGIN'
    }];

    return response;
};
```

### Azure Application Gateway

1. Go to Azure Portal → Application Gateway
2. Navigate to "Rewrites" section
3. Create a rewrite rule:
   - **Rule name:** `add-csp-header`
   - **Action type:** Set
   - **Header type:** Response
   - **Header name:** `Content-Security-Policy`
   - **Header value:** Your CSP policy

### Google Cloud Load Balancer

Use Cloud Armor security policies:

```bash
gcloud compute security-policies rules create 1000 \
    --security-policy my-policy \
    --expression "true" \
    --action "allow" \
    --description "Add CSP headers" \
    --header-action "Content-Security-Policy: default-src 'self'..."
```

### Cloudflare (CDN/Proxy)

**Using Transform Rules:**

1. Go to Cloudflare Dashboard
2. Select your domain
3. Go to "Rules" → "Transform Rules" → "Modify Response Header"
4. Create a new rule:
   - **Rule name:** Add CSP Header
   - **When incoming requests match:** All incoming requests
   - **Then:**
     - **Operation:** Set static
     - **Header name:** `Content-Security-Policy`
     - **Value:** Your CSP policy

**Using Workers (Advanced):**

```javascript
addEventListener('fetch', event => {
  event.respondWith(handleRequest(event.request))
})

async function handleRequest(request) {
  const response = await fetch(request)
  const newResponse = new Response(response.body, response)

  newResponse.headers.set('Content-Security-Policy', "default-src 'self'; script-src 'self' ...")
  newResponse.headers.set('X-Content-Type-Options', 'nosniff')
  newResponse.headers.set('X-Frame-Options', 'SAMEORIGIN')

  return newResponse
}
```

### HAProxy

Add to your HAProxy configuration:

```haproxy
frontend http-in
    bind *:80
    bind *:443 ssl crt /path/to/cert.pem

    # Add CSP header to all responses
    http-response set-header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval' c.salesforce.com cdn.pendo.io ..."
    http-response set-header X-Content-Type-Options "nosniff"
    http-response set-header X-Frame-Options "SAMEORIGIN"

    default_backend web-backend

backend web-backend
    balance roundrobin
    server web1 192.168.1.10:80 check
    server web2 192.168.1.11:80 check
```

**Reload HAProxy:**
```bash
sudo systemctl reload haproxy
```

---

## Verification Methods

### Method 1: Command Line (curl)

```bash
# Test from your server
curl -I https://app.datatoolspro.com

# Look for these headers:
# Content-Security-Policy: ...
# X-Content-Type-Options: nosniff
# X-Frame-Options: SAMEORIGIN
```

### Method 2: Browser DevTools

1. Open your application
2. Press F12
3. Go to Network tab
4. Refresh page
5. Click on the first request
6. Check "Response Headers" section

### Method 3: Online Tools

Use these security scanners to verify all layers:

- **Security Headers:** https://securityheaders.com/
- **Mozilla Observatory:** https://observatory.mozilla.org/
- **SSL Labs:** https://www.ssllabs.com/ssltest/

### Method 4: Test Route

Visit your application's test endpoint:
```
https://app.datatoolspro.com/test-csp-headers
```

This returns JSON showing CSP status and configuration.

---

## Recommended Approach

### For Maximum Security (Defense-in-Depth):

1. ✅ **Keep Laravel middleware active** (Primary layer - already configured)
2. ✅ **Enable Apache/Nginx headers** (Backup layer - configured)
3. ✅ **Configure load balancer** (Edge layer - if applicable)

### For Standard Setup:

1. ✅ **Use Laravel middleware only** (Sufficient for most cases)
2. Optional: Add web server headers for non-Laravel requests (static files)

---

## Important Notes

### Avoid Duplication Issues

When CSP is set at multiple layers, some systems may concatenate headers or cause conflicts. Test thoroughly after enabling multiple layers.

**Recommendation:**
- Start with Laravel middleware only (current setup)
- Add web server layer if serving static content directly
- Add load balancer layer only if required by infrastructure/compliance

### Monitoring

After enabling CSP at any layer, monitor for:
- Blocked resources (check browser console)
- CSP violation reports (if report-uri is configured)
- Application functionality issues

### Updating the Policy

When you need to add new domains:

1. **Update Laravel policy** (primary):
   - Edit `app/Services/Csp/Policies/MyCustomPolicy.php`
   - Run `php artisan cache:clear`

2. **Update web server config** (if enabled):
   - Edit `public/.htaccess` or Nginx config
   - Reload web server

3. **Update load balancer** (if configured):
   - Update through your provider's console/CLI

---

## Compliance Verification Checklist

Use this checklist to verify CSP is properly configured for your client:

- [ ] Application layer CSP active (Laravel middleware)
- [ ] Web server layer configured (Apache/Nginx)
- [ ] Load balancer layer configured (if applicable)
- [ ] Test endpoint responding correctly (`/test-csp-headers`)
- [ ] Browser DevTools shows CSP header
- [ ] Online security scanner shows CSP present
- [ ] Application functionality working correctly
- [ ] No blocked resources in browser console
- [ ] Documentation provided to client

---

## Support Commands

### Check Apache modules:
```bash
apache2ctl -M | grep headers
# Should show: headers_module (shared)
```

### Enable Apache mod_headers:
```bash
sudo a2enmod headers
sudo systemctl restart apache2
```

### Test Nginx config:
```bash
sudo nginx -t
```

### Check current headers:
```bash
curl -I https://app.datatoolspro.com | grep -i "content-security-policy"
```

---

## Troubleshooting

### Issue: Headers not showing up

**Solution:**
1. Verify Apache mod_headers is enabled: `apache2ctl -M | grep headers`
2. Check Laravel middleware is in web middleware group
3. Clear Laravel cache: `php artisan cache:clear`
4. Restart web server: `sudo systemctl restart apache2`

### Issue: Duplicate CSP headers

**Solution:**
1. Comment out web server CSP header (keep Laravel only)
2. Or comment out Laravel middleware (keep web server only)
3. Prefer Laravel middleware for easier management

### Issue: Resources being blocked

**Solution:**
1. Check browser console for CSP violations
2. Add blocked domains to policy
3. Update `app/Services/Csp/Policies/MyCustomPolicy.php`
4. Clear cache and test

---

## Contact

For additional support or questions about this configuration, refer to:
- Main CSP documentation: `docs/CSP_CONFIGURATION.md`
- Spatie Laravel CSP docs: https://github.com/spatie/laravel-csp
- MDN CSP Reference: https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP

---

**Last Updated:** 2025-10-13
**Version:** 1.0
**Environment:** Laravel 10.48.22 with Spatie CSP 2.10.1
