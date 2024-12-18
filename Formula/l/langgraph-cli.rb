class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https:www.github.comlangchain-ailanggraph"
  url "https:files.pythonhosted.orgpackages2a34f7ce1c93e941ea00208ba0ad1204ad62c0c2e6073712629d238b73248369langgraph_cli-0.1.64.tar.gz"
  sha256 "b3978986be9c45e8dcdacccde96440eb5de26d9c684f9216b3cddcf9fbcd2a3c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "35af0f73b395b4ac486987dd5f5f476fc26d0f65cd39af92f0d2e31fa6e59ccf"
  end

  depends_on "python@3.13"

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  def install
    virtualenv_install_with_resources
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