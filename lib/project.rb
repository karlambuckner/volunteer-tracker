class Project
  attr_reader(:title, :id)

  def initialize(project_attr)
    @title = project_attr[:title]
    @id = project_attr[:id]
  end

  def self.all
    returned_projects = DB.exec("SELECT * FROM projects;")
    projects = []
    returned_projects.each() do |project|
      projects.push(Project.new({title: project['title'], id: project['id'].to_i}))
    end
    projects
  end

  def save
    @id = DB.exec("INSERT INTO projects (title) VALUES ('#{@title}') RETURNING id").first["id"].to_i
  end

  def ==(another_project)
    self.title.==(another_project.title) and self.id.==(another_project.id)
  end

  def self.find(id)
    found_project = DB.exec("SELECT * FROM projects WHERE id = #{id}").first
    Project.new({title: found_project['title'], id: found_project['id'].to_i})
  end



end
