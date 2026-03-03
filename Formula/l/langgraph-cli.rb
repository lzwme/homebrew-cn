class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/a3/6a/c9e73635933b722e4fca31fbf49dbe23eb06efde459b3aabf5a2a6d192e5/langgraph_cli-0.4.14.tar.gz"
  sha256 "ba6bc715651d85ba94d14d6c53db87b4bf478cf45d61a28af9c8dee629f3cf1f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7362bd763f52e05a01ef2e33776aa8cba6b1a7dba2be927a82f5f35a9f294c9a"
    sha256 cellar: :any,                 arm64_sequoia: "b177d2220af9c453f14541250595c9edad0abceec68d30254b025e6940ba25b1"
    sha256 cellar: :any,                 arm64_sonoma:  "ecc3c54f2d2b8d66ecca449eae1f32e412d93913a881e949c8b6e89db1065543"
    sha256 cellar: :any,                 sonoma:        "f29cbe9360c32170a3de1aeb5c625df8a2e5f5e554e5e542ee97eabee2c70715"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b7eda3e9f04fce06708571881833348ed2f8214a24656ccc1a0d9c4d66577a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60f510d16a0c5e94dbc892cc8b449765a49164cf35618268189a9af76e55017"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/96/f0/5eb65b2bb0d09ac6776f2eb54adee6abe8228ea05b20a5ad0e4945de8aac/anyio-4.12.1.tar.gz"
    sha256 "41cfcc3a4c85d3f05c932da7c26d0201ac36f72abd4435ba90d0464a3ffed703"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "langgraph-sdk" do
    url "https://files.pythonhosted.org/packages/3a/bd/ca8ae5c6a34be6d4f7aa86016e010ff96b3a939456041565797952e3014d/langgraph_sdk-0.3.9.tar.gz"
    sha256 "8be8958529b3f6d493ec248fdb46e539362efda75784654a42a7091d22504e0e"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/53/45/b268004f745ede84e5798b48ee12b05129d19235d0e15267aa57dcdb400b/orjson-3.11.7.tar.gz"
    sha256 "9b1a67243945819ce55d24a30b59d6a168e86220452d2c96f4d1f093e71c0c49"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"langgraph", shell_parameter_format: :click)
  end

  test do
    (testpath/"graph.py").write <<~PYTHON
      from langgraph.graph import StateGraph
      builder = StateGraph(list)
      builder.add_node("anode", lambda x: ["foo"])
      builder.add_edge("__start__", "anode")
      graph = builder.compile()
    PYTHON

    (testpath/"langgraph.json").write <<~JSON
      {
        "graphs": {
          "agent": "graph.py:graph"
        },
        "env": {},
        "dependencies": ["."]
      }
    JSON

    system bin/"langgraph", "dockerfile", "DOCKERFILE"
    assert_path_exists "DOCKERFILE"
    dockerfile_content = File.read("DOCKERFILE")
    assert_match "FROM", dockerfile_content, "DOCKERFILE should contain 'FROM'"
  end
end