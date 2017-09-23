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
    found_project = nil
    Project.all().each() do |project|
      if project.id()==(id)
        found_project = project
      end
    end
    found_project
  end

  def update(update_project)
    @title = update_project[:title]
  end

  def delete
   DB.exec("DELETE FROM projects WHERE id = #{@id}")
  end

  def volunteers
    returned_volunteers = DB.exec("SELECT * FROM volunteers WHERE project_id = #{@id};")
    volunteers = []
    returned_volunteers.each() do |volunteer|
      volunteers.push(Volunteer.new({name: volunteer['name'], id: volunteer['id'].to_i, project_id: volunteer['project_id'].to_i}))
    end
    volunteers
  end
end
