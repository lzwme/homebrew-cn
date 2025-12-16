class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/11/79/6d05e94487432b31a9149b61a1f1689cbdff89f8043556f9aab264a3be87/langgraph_cli-0.4.10.tar.gz"
  sha256 "f2becdff30c52f63643d9df786ff96eb37460ebb99a01974e23093f7a674c9c8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a568bcff07218d5f8b7d660615a5bd78de1ca2a20321555325a9ab4551fa59b"
    sha256 cellar: :any,                 arm64_sequoia: "02e7c01ceca0d9c97ca57e8eee2c0d6a5e61788bd751525f9ea70e0e7e33df87"
    sha256 cellar: :any,                 arm64_sonoma:  "1cc26b2cfd0cf9cb20a98e0988013a8295bc7a5ae3967fa83f35de2c92635a59"
    sha256 cellar: :any,                 sonoma:        "d4b0703c7a85b971a5d29b401c97f96451477acfd5316e82f118693fa35db43b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c0252ab2b2c05b31ee3553301d84abf85be9b67f4741f72671d1f06bd3995d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c825ce937672e01431437ef799496cbf99dca9f969911ab298627676ec31f1fe"
  end

  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/16/ce/8a777047513153587e5434fd752e89334ac33e379aa3497db860eeb60377/anyio-4.12.0.tar.gz"
    sha256 "73c693b567b0c55130c104d0b43a9baf3aa6a31fc6110116509f27bf75e21ec0"
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
    url "https://files.pythonhosted.org/packages/2b/1b/f328afb4f24f6e18333ff357d9580a3bb5b133ff2c7aae34fef7f5b87f31/langgraph_sdk-0.3.0.tar.gz"
    sha256 "4145bc3c34feae227ae918341f66d3ba7d1499722c1ef4a8aae5ea828897d1d4"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/04/b8/333fdb27840f3bf04022d21b654a35f58e15407183aeb16f3b41aa053446/orjson-3.11.5.tar.gz"
    sha256 "82393ab47b4fe44ffd0a7659fa9cfaacc717eb617c93cde83795f14af5c2e9d5"
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