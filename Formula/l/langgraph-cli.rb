class LanggraphCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for deploying apps to the LangGraph platform"
  homepage "https:www.github.comlangchain-ailanggraph"
  url "https:files.pythonhosted.orgpackages39c16afcdf34b9fc3d42680a99a6cc08d3ce5f55a7ab49bebc4d1d0b528f1c50langgraph_cli-0.2.12.tar.gz"
  sha256 "1b3ec6017c80bdde833451d4372f5681909f73964f9cf5c84e344099faf0de09"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a2a7211c5aa51ca4afec43be958972a3fd38a266844e9b1d6f0864d2a05baa4"
    sha256 cellar: :any,                 arm64_sonoma:  "764cc2e31b043d6599ef9d01497fe143150ced0d1d5a3c4fce3e666406491732"
    sha256 cellar: :any,                 arm64_ventura: "cc83566a1572bbc204f40ff75359c0591e5482bc06d3996564fc59a6a02ca1ad"
    sha256 cellar: :any,                 sonoma:        "5316ddf290b8ae112f6e8d4b68638ac3d7d3322b64961f3b7ab0cd61cb617441"
    sha256 cellar: :any,                 ventura:       "1236915597376e5bbaa8afc8ce8f8cab4f701d9edd7598ca9ffa150f1472e461"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b52e58e8b9f34446079603d1046e83ab30f27eb8809f4e523f65632a60d58357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84f7ce0e64f0caad722b33128a54618be9bae29e2cdc2a5b79a753fde177ebef"
  end

  depends_on "python@3.13"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages957d4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "certifi" do
    url "https:files.pythonhosted.orgpackagese89ec05b3920a3b7d20d3d3310465f50348e5b3694f4f88c6daf736eef3024c4certifi-2025.4.26.tar.gz"
    sha256 "0a816057ea3cdefcef70270d2c515e4506bbc954f417fa5ade2021213bb8f0c6"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackages01ee02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages069482699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cbhttpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesb1df48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "langgraph-sdk" do
    url "https:files.pythonhosted.orgpackagesc1ddc074adf91d2fe67f00dc3be4348119f40a9d0ead9e55c958f81492c522c0langgraph_sdk-0.1.70.tar.gz"
    sha256 "cc65ec33bcdf8c7008d43da2d2b0bc1dd09f98d21a7f636828d9379535069cf9"
  end

  resource "orjson" do
    url "https:files.pythonhosted.orgpackages810bfea456a3ffe74e70ba30e01ec183a9b26bec4d497f61dcfce1b601059c60orjson-3.10.18.tar.gz"
    sha256 "e8da3947d92123eda795b68228cafe2724815621fe35e8e320a9e9593a4bcd53"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
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