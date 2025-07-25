class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https://www.github.com/langchain-ai/langgraph"
  url "https://files.pythonhosted.org/packages/05/5d/3cbafcc7ea4ff820e5798f1ae47c7a1ca094610c28f62b047d69864a0aea/langgraph_cli-0.3.6.tar.gz"
  sha256 "23f7dfa8209a2dae586a308087bf7683c35db082fca1f602b65686f9348c335b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a3b7ec3814c2f7652c2ed9a4c2a22c9c31fb339b7593de40af6b36f90ff4e4f6"
    sha256 cellar: :any,                 arm64_sonoma:  "1a68d1971eb43ac43f2822ec9cd2bea5b71bb7f37d2f106afebc7d5ca1522351"
    sha256 cellar: :any,                 arm64_ventura: "1114adf5f575089a71f633b2a1c68b52dddb33298b11e4ea15dc12ae4bddc697"
    sha256 cellar: :any,                 sonoma:        "5f48040f878f4523913e5c5d3e5659b83ba2f890a96684f0b19aad5da7fd1381"
    sha256 cellar: :any,                 ventura:       "85420636b69da841b2b57f7117d07139c8f7fb197999c8ec2a58e06de2748f30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8164737f1c22f32ab2cae8571fa58269231a80876feacc2edcaa6e19e29e3df9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1130472c8ec9fb08ccedbdf3da167a63bf97752f4b0bfdd2119851ce3cb445a3"
  end

  depends_on "rust" => :build # for orjson
  depends_on "python@3.13"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/95/7d/4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840/anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b3/76/52c535bcebe74590f296d6c77c86dabf761c41980e1347a2422e4aa2ae41/certifi-2025.7.14.tar.gz"
    sha256 "8ea99dbdfaaf2ba2f9bac77b9249ef62ec5218e7c2b2e903378ed5fccf765995"
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
    url "https://files.pythonhosted.org/packages/2a/3e/3dc45dc7682c9940db9edaf8773d2e157397c5bd6881f6806808afd8731e/langgraph_sdk-0.2.0.tar.gz"
    sha256 "cd8b5f6595e5571be5cbffd04cf936978ab8f5d1005517c99715947ef871e246"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/29/87/03ababa86d984952304ac8ce9fbd3a317afb4a225b9a81f9b606ac60c873/orjson-3.11.0.tar.gz"
    sha256 "2e4c129da624f291bcc607016a99e7f04a353f6874f3bd8d9b47b88597d5f700"
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