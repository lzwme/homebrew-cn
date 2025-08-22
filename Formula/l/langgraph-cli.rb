class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/68/49/03adce8979fd2d4c27f99f25a01df453e487f5052a33a06441cc7a94aa62/langgraph_cli-0.3.8.tar.gz"
  sha256 "29483adaa5364fc40980b10bbdabe5bf539326243d243c8bb4309c4c84c9da3c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a5a9b00d2bbd9f4ec491d2531b0ee29c25993ca4159df368a4c94084d33707eb"
    sha256 cellar: :any,                 arm64_sonoma:  "38355d4ac0cc5a15b288bbec9ad002be61fdb35489b3d121649b896fa2286ac5"
    sha256 cellar: :any,                 arm64_ventura: "394789d6d60776a299a9ef38d325742a5d8c4912391aab5a763ef65a1d896df9"
    sha256 cellar: :any,                 sonoma:        "0517457657e302cc81fbc5a00e57c6a4a82b00086fdcea19ad59a492a3f34d7a"
    sha256 cellar: :any,                 ventura:       "47fc49b779238e6d6c4e32cb1405b424be602428523521ec4da4258eedc28ec6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ef5162ec9dee92d6d318d817205675e90014d2d3bde7c576abaa7fdd04979e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fa283b6e794d5cb261fa569564a18feea3a9d1931e07e609de3cde4a7110bba"
  end

  depends_on "rust" => :build # for orjson
  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/f1/b4/636b3b65173d3ce9a38ef5f0522789614e590dab6a8d505340a4efe4c567/anyio-4.10.0.tar.gz"
    sha256 "3f3fae35c96039744587aa5b8371e7e8e603c0702999535961dd336026973ba6"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/dc/67/960ebe6bf230a96cda2e0abcf73af550ec4f090005363542f0765df162e0/certifi-2025.8.3.tar.gz"
    sha256 "e564105f78ded564e3ae7c923924435e1daa7463faeab5bb932bc53ffae63407"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
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
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "langgraph-sdk" do
    url "https://files.pythonhosted.org/packages/4d/3a/ea929b5b3827615802f020abdaa6d4a6f9d59ab764f65559fa6f87a6dda6/langgraph_sdk-0.2.2.tar.gz"
    sha256 "9484e8071953df75d7aaf9845d82db3595e485af7d5dcc235c9b32c52362e1fc"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/df/1d/5e0ae38788bdf0721326695e65fdf41405ed535f633eb0df0f06f57552fa/orjson-3.11.2.tar.gz"
    sha256 "91bdcf5e69a8fd8e8bdb3de32b31ff01d2bd60c1e8d5fe7d5afabdcf19920309"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
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