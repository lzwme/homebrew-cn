class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https:www.github.comlangchain-ailanggraph"
  url "https:files.pythonhosted.orgpackages0d657ef008cb1931009ee991bf37cc74f26ed14fb96f7f3079379ae6f455350blanggraph_cli-0.1.58.tar.gz"
  sha256 "3ca2ac0a9aa9868accdb088c5f2343766b674c7643d0467f4f91e3fab1b7efbb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5884c5eb0032e361e69227d56310e2c7180001c21e9bd30278476555d33b0fd0"
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