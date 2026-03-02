# Content Security Policy (CSP) Configuration

## Overview

This application has Content Security Policy (CSP) headers properly configured and automatically applied to all HTTP responses. The CSP implementation uses the [Spatie Laravel CSP package](https://github.com/spatie/laravel-csp) to protect against Cross-Site Scripting (XSS), data injection attacks, and other code injection vulnerabilities.

## Implementation Details

### 1. Middleware Configuration

The CSP headers are set via middleware that runs on every request:

**Location:** `app/Http/Kernel.php:42`

```php
protected $middlewareGroups = [
    'web' => [
        // ... other middleware
        \Spatie\Csp\AddCspHeaders::class, // CSP middleware
    ],
];
```

This middleware automatically adds the `Content-Security-Policy` header to all responses in the `web` middleware group.

### 2. Policy Configuration

**Custom Policy Class:** `app/Services/Csp/Policies/MyCustomPolicy.php`

**Configuration File:** `config/csp.php`

```php
'policy' => \App\Services\Csp\Policies\MyCustomPolicy::class,
'enabled' => env('CSP_ENABLED', true), // Enabled by default
```

### 3. CSP Directives

The custom policy includes the following security directives:

#### Script Sources (`script-src`)
- Self-hosted scripts
- Third-party services: Salesforce, Pendo, New Relic, Zoho, Font Awesome, jQuery, DataTables, etc.

#### Style Sources (`style-src`)
- Self-hosted styles
- External stylesheets from: Google Fonts, CDNs, Salesforce, Pendo, etc.

#### Default Sources (`default-src`)
- Fallback for unspecified directives

#### Connect Sources (`connect-src`)
- API endpoints and WebSocket connections
- Analytics and monitoring services

#### Image Sources (`img-src`)
- Self-hosted images
- Data URIs
- External image sources from trusted domains

#### Frame Sources (`frame-src`)
- YouTube embeds
- Pendo guides
- Self-hosted frames

#### Form Actions (`form-action`)
- Self-hosted forms
- Salesforce integration endpoints
- Stripe payment processing

#### Frame Ancestors (`frame-ancestors`)
- Controls which domains can embed this application

#### Worker Sources (`worker-src`)
- Service workers and web workers

## Verification

### Method 1: Automated Verification Script (Recommended)

Run the included verification script:

```bash
# Make the script executable (first time only)
chmod +x verify-csp.sh

# Run the script on production
./verify-csp.sh https://app.datatoolspro.com

# Or test locally
./verify-csp.sh http://localhost:8000
```

This script will check:
- ✓ Application connectivity
- ✓ Content-Security-Policy header presence
- ✓ Other security headers (X-Content-Type-Options, X-Frame-Options, etc.)
- ✓ Test endpoint functionality
- ✓ Complete response headers

### Method 2: Test Endpoint

Visit the test endpoint in your browser or via curl:

```bash
# Browser
https://app.datatoolspro.com/test-csp-headers

# Command line
curl https://app.datatoolspro.com/test-csp-headers
```

**Expected Response:**
```json
{
  "message": "CSP headers are configured and active",
  "instructions": "Check the response headers in your browser DevTools Network tab for Content-Security-Policy header",
  "timestamp": "2025-10-13 10:30:00",
  "csp_enabled": true,
  "csp_policy": "App\\Services\\Csp\\Policies\\MyCustomPolicy"
}
```

### Method 3: Browser DevTools

1. Open your application in a web browser
2. Open Developer Tools (F12)
3. Navigate to the **Network** tab
4. Refresh the page
5. Click on the main document request (usually the first one)
6. Look at the **Response Headers** section
7. You should see: `Content-Security-Policy: <policy directives>`

### Method 4: Command Line (curl)

```bash
# Check main application
curl -I https://app.datatoolspro.com

# Look for the Content-Security-Policy header
curl -I https://app.datatoolspro.com | grep -i "content-security-policy"
```

### Method 5: Online Security Scanners

Use online security header checkers to get a comprehensive security grade:
- [Security Headers](https://securityheaders.com/) - Enter your URL for full report
- [Mozilla Observatory](https://observatory.mozilla.org/) - Comprehensive security analysis
- [SSL Labs](https://www.ssllabs.com/ssltest/) - SSL/TLS and security headers check

Simply enter your application URL and these tools will analyze your security headers, including CSP.

## Environment Configuration

The CSP can be toggled via environment variable:

```env
# .env file
CSP_ENABLED=true  # Set to false to disable CSP (not recommended for production)
```

**Default:** Enabled (true)

## Compliance Statement

### Client Requirement
> "Ensure that your web server, application server, load balancer, etc. is configured to set the Content-Security-Policy header."

### Implementation Status
**✓ COMPLIANT**

The Content-Security-Policy header is configured and automatically set by the Laravel application middleware layer for all HTTP responses. This is the standard and recommended approach for Laravel applications.

The CSP implementation:
- ✓ Sets the `Content-Security-Policy` header on every response
- ✓ Uses a custom policy tailored to the application's needs
- ✓ Includes all necessary third-party domains
- ✓ Can be enabled/disabled via environment configuration
- ✓ Follows industry best practices

## Security Benefits

The implemented CSP provides protection against:

1. **Cross-Site Scripting (XSS)** - By controlling which scripts can execute
2. **Data Injection Attacks** - By restricting data sources
3. **Clickjacking** - Via frame-ancestors directive
4. **Mixed Content** - By enforcing HTTPS for external resources
5. **Unauthorized Third-Party Resources** - By whitelisting trusted domains

## Maintenance

### Adding New Domains

If you need to add new external resources (CDNs, APIs, etc.):

1. Edit `app/Services/Csp/Policies/MyCustomPolicy.php`
2. Add the domain to the appropriate directive
3. Clear the application cache: `php artisan cache:clear`
4. Test the changes in your browser

### Testing Changes

When modifying CSP policies:

1. Use `report_only_policy` in `config/csp.php` to test without breaking functionality
2. Monitor console errors in browser DevTools
3. Check for blocked resources
4. Update the policy as needed

## Additional Server-Level Configuration (Optional)

While the application-level CSP is sufficient, you can add defense-in-depth by also configuring CSP at the web server level:

### Apache (.htacache - public/.htaccess)
```apache
<IfModule mod_headers.c>
    Header set Content-Security-Policy "your-policy-here"
</IfModule>
```

### Nginx (server configuration)
```nginx
add_header Content-Security-Policy "your-policy-here" always;
```

**Note:** Server-level configuration is optional since the application middleware already handles CSP.

## References

- [Spatie Laravel CSP Documentation](https://github.com/spatie/laravel-csp)
- [MDN Web Docs - CSP](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)
- [Content Security Policy Reference](https://content-security-policy.com/)

## Support

For questions or modifications to the CSP policy, contact the development team or refer to the Spatie Laravel CSP package documentation.

---

**Last Updated:** 2025-10-13
**Version:** 1.0
**Package Version:** spatie/laravel-csp 2.10.1
