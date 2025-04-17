class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https:www.github.comlangchain-ailanggraph"
  url "https:files.pythonhosted.orgpackages7ccd9dd702ccf2f8708a2fd6c3e1346b6110e4fedd92148fa6647ea9bba6c6f8langgraph_cli-0.2.4.tar.gz"
  sha256 "27db1a49bf78131ae7f20304e849e5c4bac9c2d02d9cd76b593463c291184d76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "44e4236fe68747c94a21db0ce7e7d505d95174f78a34e94428136c8e045299af"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "44e4236fe68747c94a21db0ce7e7d505d95174f78a34e94428136c8e045299af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "44e4236fe68747c94a21db0ce7e7d505d95174f78a34e94428136c8e045299af"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc8056eb893d4f14d8741e568d4f1e9723e219846df95bd4a80daa1f43d8c042"
    sha256 cellar: :any_skip_relocation, ventura:       "fc8056eb893d4f14d8741e568d4f1e9723e219846df95bd4a80daa1f43d8c042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44e4236fe68747c94a21db0ce7e7d505d95174f78a34e94428136c8e045299af"
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