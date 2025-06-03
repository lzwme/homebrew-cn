class Aqtinstall < Formula
  include Language::Python::Virtualenv

  desc "Another unofficial Qt installer"
  homepage "https:github.commiurahraqtinstall"
  url "https:files.pythonhosted.orgpackages761924a588de6c25d43169d172dab47e63a63cd0d8f90e98cf86487acbf00ac7aqtinstall-3.3.0.tar.gz"
  sha256 "9c7d85fbe7258be2d7d23fda33f8aff2e8b7536817255eaeaaf4226da8546a31"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9c9dd5e40d7bd533d8da2bb74d7315449731b18f7bb700a744070cd7d00c02c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be17bb4b99450b17dc24764ae573bdc60efff0eb47a74264980c605ffafa175e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "01ae5a1db0def636b7a76062c68a9a147e2376abb916ec899b96e411ca4dc647"
    sha256 cellar: :any_skip_relocation, sonoma:        "a4e8a129ef5f6c66f9d7891e0bd803059b60e66e3763b96c97043267c79b085a"
    sha256 cellar: :any_skip_relocation, ventura:       "a2a5b8af8f1f847dd0b6cf7f07d3d99b752ce7775f58e59e7410dbd8da15d1b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe5793553ea949f4aab1c7fa0da26925a6e285b08f5c4cb88c0ae3b82437644d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ed0671250344889120e275dd0e377d74e3276dbd4b3387a68f4cc0e87568829"
  end

  depends_on "python@3.13"

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesd8e40c4c39e18fd76d6a628d4dd8da40543d136ce2d1752bd6eeeab0791f4d6bbeautifulsoup4-4.13.4.tar.gz"
    sha256 "dbb3c4e1ceae6aefebdaf2423247260cd062430a410e38c66f2baa50a8437195"
  end

  resource "brotli" do
    url "https:files.pythonhosted.orgpackages2fc2f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787bBrotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "bs4" do
    url "https:files.pythonhosted.orgpackagesc9aa4acaf814ff901145da37332e05bb510452ebed97bc9602695059dd46ef39bs4-0.0.2.tar.gz"
    sha256 "a48685c58f50fe127722417bae83fe6badf500d54b55f7e39ffe43b798653925"
  end

  resource "certifi" do
    url "https:files.pythonhosted.orgpackagese89ec05b3920a3b7d20d3d3310465f50348e5b3694f4f88c6daf736eef3024c4certifi-2025.4.26.tar.gz"
    sha256 "0a816057ea3cdefcef70270d2c515e4506bbc954f417fa5ade2021213bb8f0c6"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "humanize" do
    url "https:files.pythonhosted.orgpackages22d1bbc4d251187a43f69844f7fd8941426549bbe4723e8ff0a7441796b0789fhumanize-4.12.3.tar.gz"
    sha256 "8430be3a615106fdfceb0b2c1b41c4c98c6b0fc5cc59663a5539b111dd325fb0"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "inflate64" do
    url "https:files.pythonhosted.orgpackagese3a7974e6daa6c353cf080b540c18f11840e81b36d18106963a0a857b1fc2adfinflate64-1.0.3.tar.gz"
    sha256 "a89edd416c36eda0c3a5d32f31ff1555db2c5a3884aa8df95e8679f8203e12ee"
  end

  resource "multivolumefile" do
    url "https:files.pythonhosted.orgpackages50f0a7786212b5a4cb9ba05ae84a2bbd11d1d0279523aea0424b6d981d652a14multivolumefile-0.2.3.tar.gz"
    sha256 "a0648d0aafbc96e59198d5c17e9acad7eb531abea51035d08ce8060dcad709d6"
  end

  resource "patch-ng" do
    url "https:files.pythonhosted.orgpackageseec053a2f017ac5b5397a7064c2654b73c3334ac8461315707cbede6c12199ebpatch-ng-1.18.1.tar.gz"
    sha256 "52fd46ee46f6c8667692682c1fd7134edc65a2d2d084ebec1d295a6087fc0291"
  end

  resource "psutil" do
    url "https:files.pythonhosted.orgpackages2a80336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3depsutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "py7zr" do
    url "https:files.pythonhosted.orgpackages9762d6f18967875aa60182198a0dd287d3a50d8aea1d844239ea00c016f7be88py7zr-1.0.0.tar.gz"
    sha256 "f6bfee81637c9032f6a9f0eb045a4bfc7a7ff4138becfc42d7cb89b54ffbfef1"
  end

  resource "pybcj" do
    url "https:files.pythonhosted.orgpackagesce75bbcf098abf68081fa27c09d642790daa99d9156132c8b0893e3fecd946abpybcj-1.0.6.tar.gz"
    sha256 "70bbe2dc185993351955bfe8f61395038f96f5de92bb3a436acb01505781f8f2"
  end

  resource "pycryptodomex" do
    url "https:files.pythonhosted.orgpackagesc985e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pyppmd" do
    url "https:files.pythonhosted.orgpackagesf6d7b3084ff1ac6451ef7dd93d4f7627eeb121a3bed4f8a573a81978a43ddb06pyppmd-1.2.0.tar.gz"
    sha256 "cc04af92f1d26831ec96963439dfb27c96467b5452b94436a6af696649a121fd"
  end

  resource "pyzstd" do
    url "https:files.pythonhosted.orgpackages8fa254d860ccbd07e3c67e4d0321d1c29fc7963ac82cf801a078debfc4ef7c15pyzstd-0.17.0.tar.gz"
    sha256 "d84271f8baa66c419204c1dd115a4dec8b266f8a2921da21b81764fa208c1db6"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "semantic-version" do
    url "https:files.pythonhosted.orgpackages7d31f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackages3ff44a80cd6ef364b2e8b65b15816a843c0980f7a5a2b4dc701fc574952aa19fsoupsieve-2.7.tar.gz"
    sha256 "ad282f9b6926286d2ead4750552c8a6142bc4c783fd66b0293547c8fe6ae126a"
  end

  resource "texttable" do
    url "https:files.pythonhosted.orgpackages1cdc0aff23d6036a4d3bf4f1d8c8204c5c79c4437e25e0ae94ffe4bbb55ee3c2texttable-1.7.0.tar.gz"
    sha256 "2d2068fb55115807d3ac77a4ca68fa48803e84ebb0ee2340f858107a36522638"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf63723083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "clang_64", shell_output("#{bin}aqt list-qt mac desktop --arch 6.7.0")
    assert_match "linux_gcc_64", shell_output("#{bin}aqt list-qt linux desktop --arch 6.7.0")
  end
end