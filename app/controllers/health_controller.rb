class HealthController < ApplicationController
  skip_before_action :authenticate_request, raise: false

  def index
    begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      db_status = "ok"
    rescue => e
      db_status = "error"
      Rails.logger.error("Database health check failed: #{e.message}")
    end

    health_status = {
      status: db_status == "ok" ? "healthy" : "unhealthy",
      timestamp: Time.current.iso8601,
      database: db_status,
      environment: Rails.env,
      version: "1.0.0"
    }

    status_code = health_status[:status] == "healthy" ? :ok : :service_unavailable
    render json: health_status, status: status_code
  end
end
