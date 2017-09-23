require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/project")
require ("./lib/volunteer")
require("pg")

DB = PG.connect({:dbname => "volunteer_tracker"})

get("/") do
  @project_list = Project.all()
  erb(:index)
end

post("/") do
  title = params.fetch("title")
  new_project = Project.new({:title => title, :id => nil})
  new_project.save
  new_project
  redirect "/"
end
