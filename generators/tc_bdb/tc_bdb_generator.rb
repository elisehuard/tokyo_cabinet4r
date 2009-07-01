class TcBdbGenerator < Rails::Generator::NamedBase

  def manifest
    record do |m|
      m.class_collisions class_name, "#{class_name}Test"
      m.template "tokyo_cabinet_bdb.rb.erb",
           "app/models/#{name.underscore}.rb", :assigns => { :model_name => name.camelize } 

    end
  end
end
