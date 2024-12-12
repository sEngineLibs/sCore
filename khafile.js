let project = new Project("New Project");

project.addAssets("Assets/**");
project.addShaders("Shaders/**");
project.addSources("Sources");

project.addDefine("SUI_DEBUG_FPS");

resolve(project);
