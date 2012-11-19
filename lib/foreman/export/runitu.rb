require "erb"
require "foreman/export"

class Foreman::Export::Runitu < Foreman::Export::Base

  @template_root = Pathname.new(File.dirname(__FILE__)).join('../../../data/templates')

  class << self
    attr_reader :template_root
  end

  ENV_VARIABLE_REGEX = /([a-zA-Z_]+[a-zA-Z0-9_]*)=(\S+)/

   def export_from_base
     error("Must specify a location") unless location
     FileUtils.mkdir_p(location) rescue error("Could not create: #{location}")
     FileUtils.mkdir_p(log) rescue error("Could not create: #{log}")
     #FileUtils.chown(user, nil, log) rescue error("Could not chown #{log} to #{user}")
   end

  def export
    template_root = Pathname.new(File.dirname(__FILE__)).join('../../../data/export/runitu').to_s

    engine.each_process do |name, process|
      1.upto(engine.formation[name]) do |num|
        process_directory = "#{app}-#{name}-#{num}"

        create_directory process_directory
        create_directory "#{process_directory}/env"
        create_directory "#{process_directory}/log"

        write_template "#{template_root}/run.erb", "#{process_directory}/run", binding
        chmod 0755, "#{process_directory}/run"

        port = engine.port_for(process, num)
        engine.env.merge("PORT" => port.to_s).each do |key, value|
          write_file "#{process_directory}/env/#{key}", value
        end

        write_template "#{template_root}/log/run.erb", "#{process_directory}/log/run", binding
        chmod 0755, "#{process_directory}/log/run"
      end
    end
  end

  def export_template(name, file = nil, template_root = nil)
    File.read(name)
  end
end
