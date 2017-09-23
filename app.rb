require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/project")
require ("./lib/volunteer")
require("pg")

DB = PG.connect({:dbname => "volunteer_tracker"})

get("/") do
  @projects= Project.all()
  @volunteers = Volunteer.all()
  erb(:index)
end

post("/projects") do
  title = params["title"]
  @project = Project.new({:id => nil, :title => title})
  @project.save
  @projects = Project.all
  erb(:index)
end

get("/projects/:id") do
  @project_id = params[:id]
  @project = Project.find(params["id"].to_i)
  @volunteers = Volunteer.all
  erb(:project_modify)
end

get("/projects/:id/edit") do
  @project_id = params[:id]
  @project = Project.find(params["id"].to_i)
  erb(:project)
end

post("/projects/:id/edit") do
  title = params['title']
  @project_id = params[:id]
  @project = Project.find(params["id"].to_i)
  @project.update({:title => title})
  erb(:project_modify)
end
