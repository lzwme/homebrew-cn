class Harlequin < Formula
  include Language::Python::Virtualenv

  desc "Easy, fast, and beautiful database client for the terminal"
  homepage "https:harlequin.sh"
  url "https:files.pythonhosted.orgpackagesbbc10fc47822534938e73f070eb485059be414bb6ee274ac05e1d5d695fb4c24harlequin-1.25.2.tar.gz"
  sha256 "8319da69b07afd063e1296ebba1569374daa171489b97bd35d2dbdae802e6144"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a0325720a564ef70170a8678b274989f790c8a9c6f941ce8d0de28ccd2886097"
    sha256 cellar: :any,                 arm64_sonoma:  "85bcdff85ce10a5347c4aa11dd122530113712c8822bb71fa6b5bcd2d62ddce4"
    sha256 cellar: :any,                 arm64_ventura: "d53144065dbf6f3795184304a15a683d150f5739c6e65af081b9f89d64d914d0"
    sha256 cellar: :any,                 sonoma:        "4cbdc353f11b180b0c3b4f2e30efe8bd9dea204f4419afc83cdfa5d4d30f91b0"
    sha256 cellar: :any,                 ventura:       "a35f1ea5b322961525aa3ff9450531e80b97f57b27fbdc99a06ae453b1e4038e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "624d397576b9b0d573162619a8fd98f46f01dc3bd5cba0546efb7d5c439520a1"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "apache-arrow"
  depends_on "python@3.11"

  on_linux do
    depends_on "patchelf" => :build # for pyarrow
  end

  resource "cython" do
    url "https:files.pythonhosted.orgpackages2a978cc3fe7c6de4796921236a64d00ca8a95565772e57f0d3caae68d880b592Cython-0.29.37.tar.gz"
    sha256 "f813d4a6dd94adee5d4ff266191d1d95bf6d4164a4facc535422c021b2504cfb"
  end

  resource "meson-python" do
    url "https:files.pythonhosted.orgpackagesa23b276b596824a0820987fdcc7721618453b4f9a8305fe20b611a00ac3f948emeson_python-0.15.0.tar.gz"
    sha256 "fddb73eecd49e89c1c41c87937cd89c2d0b65a1c63ba28238681d4bd9484d26f"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "duckdb" do
    url "https:files.pythonhosted.orgpackagesa0d7ec014b351b6bb026d5f473b1d0ec6bd6ba40786b9abbf530b4c9041d9895duckdb-1.1.3.tar.gz"
    sha256 "68c3a46ab08836fe041d15dcbf838f74a990d551db47cb24ab1c4576fc19351c"
  end

  resource "Jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "linkify-it-py" do
    url "https:files.pythonhosted.orgpackages2aaebb56c6828e4797ba5a4821eec7c43b8bf40f69cda4d4f5f8c8a2810ec96alinkify-it-py-2.0.3.tar.gz"
    sha256 "68cda27e162e9215c17d786649d1da0021a451bdc436ef9e0fa0ba5234b9b048"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "MarkupSafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdit-py-plugins" do
    url "https:files.pythonhosted.orgpackages1903a2ecab526543b152300717cf232bb4bb8605b6edb946c845016fa9c9c9fdmdit_py_plugins-0.4.2.tar.gz"
    sha256 "5f2cd1fdb606ddf152d37ec30e46101a60512bc0e5fa1a7002c36647b09e26b5"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "numpy" do
    url "https:files.pythonhosted.orgpackages656e09db70a523a96d25e115e71cc56a6f9031e7b8cd166c1ac8438307c14058numpy-1.26.4.tar.gz"
    sha256 "2a02aba9ed12e4ac4eb3ea9421c420301a0c6460d9830d74a9df87efa4912010"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesfb93180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "pyarrow" do
    url "https:files.pythonhosted.orgpackages7f7b640785a9062bb00314caa8a387abce547d2a420cf09bd6c715fe659ccffbpyarrow-18.1.0.tar.gz"
    sha256 "9386d3ca9c145b5539a1cfc75df07757dff870168c959b473a0bccbc3abc8c73"
  end

  resource "Pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyperclip" do
    url "https:files.pythonhosted.orgpackages30232f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60dpyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "questionary" do
    url "https:files.pythonhosted.orgpackages84d0d73525aeba800df7030ac187d09c59dc40df1c878b4fab8669bdc805535dquestionary-2.0.1.tar.gz"
    sha256 "bcce898bf3dbb446ff62830c86c5c6fb9a22a54146f0f5597d3da43b10d8fc8b"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rich-click" do
    url "https:files.pythonhosted.orgpackagesfcf4e48dc2850662526a26fb0961aacb0162c6feab934312b109b748ae4efee2rich_click-1.8.4.tar.gz"
    sha256 "0f49471f04439269d0e66a6f43120f52d11d594869a2a0be600cfb12eb0616b9"
  end

  resource "shandy-sqlfmt" do
    url "https:files.pythonhosted.orgpackages3938f634ed73c65ba8e8061c65479af73e0b4afa53530af026489ca17b549559shandy_sqlfmt-0.24.0.tar.gz"
    sha256 "ae34d34dc88ef4a2c97677d7d3d95d7f362908aa6f97e3fb0529cab4a96799ba"
  end

  resource "textual" do
    url "https:files.pythonhosted.orgpackagesf0efd498d5eb07ebe63299517bbee7e4be2fe8e1b4f0835763446cef1c4eaed0textual-0.85.0.tar.gz"
    sha256 "645c0fd0b4f61cd19383df78a1acd4f3b555e2c514cfa2f454e20692dffc10a0"
  end

  resource "textual-fastdatatable" do
    url "https:files.pythonhosted.orgpackagesb69082cf71355563743cbf5ece0c51dac7b60503c5e3c12fb81f3cb642ec1cd2textual_fastdatatable-0.10.0.tar.gz"
    sha256 "e39b8ba54cc16fec47f9af8320589707862369bc85138c26bf54f0dc9b69368c"
  end

  resource "textual-textarea" do
    url "https:files.pythonhosted.orgpackages58ea0b9edcdc13dbf23389980be7e9c2aa9fe3bedd3958138a28294e364651b5textual_textarea-0.14.4.tar.gz"
    sha256 "560489179b19426b8546b8521750acde22f57021b3afc08b0643557048fb7315"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagesb109a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fatomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "tree-sitter" do
    url "https:files.pythonhosted.orgpackages4a6471b3a0ff7d0d89cb333caeca01992099c165bdd663e7990ea723615e60f4tree_sitter-0.20.4.tar.gz"
    sha256 "6adb123e2f3e56399bbf2359924633c882cc40ee8344885200bca0922f713be5"
  end

  # sdist issue report, https:github.comgrantjenkspy-tree-sitter-languagesissues63
  # https:github.comgrantjenkspy-tree-sitter-languagesissues54
  resource "tree-sitter-languages" do
    url "https:github.comgrantjenkspy-tree-sitter-languagesarchiverefstagsv1.10.2.tar.gz"
    sha256 "cdd03196ebaf8f486db004acd07a5b39679562894b47af6b20d28e4aed1a6ab5"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "uc-micro-py" do
    url "https:files.pythonhosted.orgpackages917a146a99696aee0609e3712f2b44c6274566bc368dfe8375191278045186b8uc-micro-py-1.0.3.tar.gz"
    sha256 "d321b92cff673ec58027c04015fcaa8bb1e005478643ff4a500882eaab88c48a"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}harlequin --profile none", 2)
    assert_match "Harlequin couldn't load your profile", output

    assert_match version.to_s, shell_output("#{bin}harlequin --version")
  end
end