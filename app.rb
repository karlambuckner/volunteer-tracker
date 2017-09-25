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
  name = params['name']
  erb(:index)
end

get("/projects/:id") do
  @project_id = params[:id]
  @project = Project.find(params["id"].to_i)
  @volunteers = Volunteer.all
  erb(:project)
end

get("/projects/:id/edit") do
  @project_id = params[:id]
  @project = Project.find(params["id"].to_i)
  erb(:project_modify)
end

post("/projects/:id/edit") do
  title = params['title']
  @project_id = params[:id]
  @project = Project.find(params["id"].to_i)
  @project.update({:title => title})
  erb(:project_modify)
end

delete("/projects/:id/edit") do
  @project_id = params[:id]
  @project = Project.find(params["id"].to_i)
  @project.delete
  @projects = Project.all
  erb(:index)
end

get("/volunteer/:id") do
  @volunteer = Volunteer.find(params["id"].to_i)
  erb(:volunteer)
end


post("/projects/:project_id/volunteers") do
  project_id = params[:project_id]
  name = params['name']
  volunteer = Volunteer.new({:name => name, :project_id => project_id})
  volunteer.save
  redirect("/projects/#{project_id}")
end

post("/volunteer/:id") do
  name = params['name']
  volunteer_id = params[:project_id]
  @volunteer = Volunteer.find(params["id"].to_i)
  @volunteer.update({:name => name})
  erb(:volunteer)
end
