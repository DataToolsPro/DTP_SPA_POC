function App() {
  return (
    <main style={{ padding: '2rem', fontFamily: 'system-ui' }}>
      <h1>Hello from DataTools Pro</h1>
      <p>
        API URL: {import.meta.env.VITE_API_URL ?? 'http://localhost:8000/api'}
      </p>
    </main>
  )
}

export default App
