class SecretFile

  def initialize(secret_data, security_logger)
    @data = secret_data
    @security = security_logger
  end
  
  def get_data
    @security.create_log_entry
    @data
  end
end

class SecurityLogger
  def create_log_entry
    puts "Log entry created"
  end
end


security1 = SecurityLogger.new
secret1 = SecretFile.new("clinton", security1)

p secret1.get_data