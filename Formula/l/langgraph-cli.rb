class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https:www.github.comlangchain-ailanggraph"
  url "https:files.pythonhosted.orgpackages816549f9b4a2660343edab02aedfe355932c454d650a41adf067def514558305langgraph_cli-0.2.6.tar.gz"
  sha256 "5124cef6f78cdba3d2a67cd7d54e54ed7f9dc387b05c6eef0a68ca5b29124f73"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8c4a9c95cbade8b9c2caf82f9892e9eec739e264e63da27117fe13d5424d69a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8c4a9c95cbade8b9c2caf82f9892e9eec739e264e63da27117fe13d5424d69a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8c4a9c95cbade8b9c2caf82f9892e9eec739e264e63da27117fe13d5424d69a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1014393dd89adcd67a5dc8c64ff8ceeda72d0d09953591cc498a54ea45a55452"
    sha256 cellar: :any_skip_relocation, ventura:       "1014393dd89adcd67a5dc8c64ff8ceeda72d0d09953591cc498a54ea45a55452"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8c4a9c95cbade8b9c2caf82f9892e9eec739e264e63da27117fe13d5424d69a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8c4a9c95cbade8b9c2caf82f9892e9eec739e264e63da27117fe13d5424d69a"
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