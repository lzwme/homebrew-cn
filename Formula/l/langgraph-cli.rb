class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https:www.github.comlangchain-ailanggraph"
  url "https:files.pythonhosted.orgpackages091df142a6a0727e3236c5ed213704bbec9b0ebb5646f8d1f87f9935835729calanggraph_cli-0.1.81.tar.gz"
  sha256 "6d03c8c8306b3c241f6c5f8c9c632a82005b912eb36314170140a5559a3c6f32"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "905751d2ab02450caf27f7053880e651578dc9f020e4b3ae129bbb87a0358b7d"
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