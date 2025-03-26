class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https:www.github.comlangchain-ailanggraph"
  url "https:files.pythonhosted.orgpackagesb52bba33e45ea8cca0e11bf3df5b4e1a42c361eca49448b8d6de6b948d9f17dclanggraph_cli-0.1.80.tar.gz"
  sha256 "a3ae17586b166a710119cd2d93395e1289e99c2377863544a5e163334fbfdc6a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d3bb2f6e233c15398da5cb9b5195a71a0df0d540398be5850511a071244fdc67"
  end

  depends_on "python@3.13"

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"langgraph", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    (testpath"graph.py").write <<~PYTHON
      from langgraph.graph import StateGraph
      builder = StateGraph(list)
      builder.add_node("anode", lambda x: ["foo"])
      builder.add_edge("__start__", "anode")
      graph = builder.compile()
    PYTHON

    (testpath"langgraph.json").write <<~JSON
      {
        "graphs": {
          "agent": "graph.py:graph"
        },
        "env": {},
        "dependencies": ["."]
      }
    JSON

    system bin"langgraph", "dockerfile", "DOCKERFILE"
    assert_path_exists "DOCKERFILE"
    dockerfile_content = File.read("DOCKERFILE")
    assert_match "FROM", dockerfile_content, "DOCKERFILE should contain 'FROM'"
  end
end