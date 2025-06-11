class Easyeda2kicad < Formula
  include Language::Python::Virtualenv

  desc "Converts electronic components from EasyEDA or LCSC to a KiCad library"
  homepage "https:github.comuPesyeasyeda2kicad.py"
  url "https:files.pythonhosted.orgpackagesf178fde265892294c733590a9089f37cc8ea1478b9c632d76c0a11b8f20fe6f3easyeda2kicad-0.8.0.tar.gz"
  sha256 "a781be6d1076f6e06886a4292373eb930c9921de4c709d6dd91bb6ea104f4a4b"
  license "AGPL-3.0-or-later"
  revision 1
  head "https:github.comuPesyeasyeda2kicad.py.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b7633baccb1d349a9033a5087e89e62a46c5868867a6a0bd848771793f87a0e7"
    sha256 cellar: :any,                 arm64_sonoma:  "8b4ef42257e4e4b65b310937bf8be924d32b783f74861d8079b333191b0395a6"
    sha256 cellar: :any,                 arm64_ventura: "04618b2f9c21f68c67e50e32c9e320964a7fbabaa87feafb44247eb8c6eb03c8"
    sha256 cellar: :any,                 sonoma:        "3be194ac4a6a38447dbaadbb45e754725170173ea435d23f94e76c1b234c37a5"
    sha256 cellar: :any,                 ventura:       "30c09fef7e23b436b8d1f9ff76fdbcbdf67aaa5a373386d202e84cb07a0b6dc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f1bb0696e102a011ab2e77892fe7fd651890cac8ea4b3a383fbd09dca845dfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1dca63ab329b72627e5c6d87ace9536aee6b4b940b25982f8d960948b42c9f64"
  end

  depends_on "rust" => :build
  depends_on "python@3.13"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "certifi" do
    url "https:files.pythonhosted.orgpackagese89ec05b3920a3b7d20d3d3310465f50348e5b3694f4f88c6daf736eef3024c4certifi-2025.4.26.tar.gz"
    sha256 "0a816057ea3cdefcef70270d2c515e4506bbc954f417fa5ade2021213bb8f0c6"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesf0868ce9040065e8f924d642c58e4a344e33163a07f6b57f836d0d734e0ad3fbpydantic-2.11.5.tar.gz"
    sha256 "7f853db3d0ce78ce8bbb148c401c2cdd6431b3473c0cdff2755c7690952a7b7a"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesad885f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackagesf8b10c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin"easyeda2kicad", "--full", "--lcsc_id=C2040", "--output", testpath"lib"
    assert_path_exists testpath"lib.3dshapes"
    assert_path_exists testpath"lib.kicad_sym"
    assert_path_exists testpath"lib.pretty"
  end
end