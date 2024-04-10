Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'https://skyva-front.vercel.app', 'https://skyva-admin.vercel.app', 'http://localhost:3000'
  
      resource '*', 
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options]
    end
  end
  