class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https:www.github.comlangchain-ailanggraph"
  url "https:files.pythonhosted.orgpackagesaf2776ee700f482148c64bc86df53822b262fa6129027e7232b4cab4ad22296alanggraph_cli-0.1.53.tar.gz"
  sha256 "683774a0cacc658c77de0cf719ffbe5d9b024f33792244230df24a3aa7b2cc33"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb9b138d625365fc491310952fa72fd45fa8a6514590766f5b2c408d57a186cd"
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