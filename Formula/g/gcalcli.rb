class Gcalcli < Formula
  include Language::Python::Virtualenv

  desc "Easily access your Google Calendar(s) from a command-line"
  homepage "https:github.cominsanumgcalcli"
  url "https:files.pythonhosted.orgpackagesf0a3713e440c41a9dcbace59b864097c439c0b7248c5d7bfad8a8b0fcc7ed096gcalcli-4.4.0.tar.gz"
  sha256 "198c5046e2bd50ae4cc17fb95a27dac46cb175f91a9d9322b0e08fed577bba88"
  license "MIT"
  head "https:github.cominsanumgcalcli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65a8472a556e1acf71b7ef8ab01f6e143b684cc4433733186bca7a218ce9d7a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edbb7426e416ddac610e6681f2977f531a1cb7316f0cd398de46bb002fbb082e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fb6e08408832a39c27f447d83e34474977bee90ff733f57cfcd30e15d66ad39"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b23a74a5b73950c08a30f4a57ffa9e515f615f966f0d90c2c00e9c968df831b"
    sha256 cellar: :any_skip_relocation, ventura:        "d82353631f52a5f662906353c649135a1dc2c110cd43e73fe0c30ff0a2f20b8b"
    sha256 cellar: :any_skip_relocation, monterey:       "99c9e17463af03f610f769ea8bcf7d3e530ad097c9c4274179c85b9b0b330e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08cf07853c2d9b2ef96ae17177b1c3c864907e27760d8ff6062bb8bfe5b9f9d8"
  end

  depends_on "cmake" => :build # for google_api_python_client_stubs
  depends_on "pkg-config" => :build
  depends_on "rust" => :build # for google_api_python_client_stubs
  depends_on "certifi"
  depends_on "python@3.12"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7533a3d23a2e9ac78f9eaf1fce7490fee430d43ca7d42c65adabbb36a2b28ff6argcomplete-3.5.0.tar.gz"
    sha256 "4349400469dccfb7950bb60334a680c58d88699bff6159df61251878dc6bf74b"
  end

  resource "cachetools" do
    url "https:files.pythonhosted.orgpackagesc338a0f315319737ecf45b4319a8cd1f3a908e29d9277b46942263292115eee7cachetools-5.5.0.tar.gz"
    sha256 "2cc24fb4cbe39633fb7badd9db9ca6295d766d9c2995f245725a46715d050f2a"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "google-api-core" do
    url "https:files.pythonhosted.orgpackages781499c2514b3ccc5aad1e0776f0ae8295c9f7153aead4f41d07dd126cecdc14google_api_core-2.19.2.tar.gz"
    sha256 "ca07de7e8aa1c98a8bfca9321890ad2340ef7f2eb136e558cee68f24b94b0a8f"
  end

  resource "google-api-python-client" do
    url "https:files.pythonhosted.orgpackages99c2efec3de62b53d3ac9709aa4f4e1c475041e973578e0c448fb76355b72c27google_api_python_client-2.143.0.tar.gz"
    sha256 "6a75441f9078e6e2fcdf4946a153fda1e2cc81b5e9c8d6e8c0750c85c7f8a566"
  end

  resource "google-api-python-client-stubs" do
    url "https:files.pythonhosted.orgpackagesc0c760e5298981ac5ea4aaca007584680c1850f4d737edba9e5e6a7dda578f88google_api_python_client_stubs-1.27.0.tar.gz"
    sha256 "148e16613e070969727f39691e23a73cdb87c65a4fc8133abd4c41d17b80b313"
  end

  resource "google-auth" do
    url "https:files.pythonhosted.orgpackages0fae634dafb151366d91eb848a25846a780dbce4326906ef005d199723fbbca0google_auth-2.34.0.tar.gz"
    sha256 "8eb87396435c19b20d32abd2f984e31c191a15284af72eb922f10e5bde9c04cc"
  end

  resource "google-auth-httplib2" do
    url "https:files.pythonhosted.orgpackages56be217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacefgoogle-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "google-auth-oauthlib" do
    url "https:files.pythonhosted.orgpackagescc0f1772edb8d75ecf6280f1c7f51cbcebe274e8b17878b382f63738fd96cee5google_auth_oauthlib-1.2.1.tar.gz"
    sha256 "afd0cad092a2eaa53cd8e8298557d6de1034c6cb4a740500b5357b648af97263"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages533b1599ceafa875ffb951480c8c74f4b77646a6b80e80970698f2aa93c216cegoogleapis_common_protos-1.65.0.tar.gz"
    sha256 "334a29d07cddc3aa01dee4988f9afd9b2916ee2ff49d6b757155dc0d197852c0"
  end

  resource "httplib2" do
    url "https:files.pythonhosted.orgpackages3dad2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagese8ace349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72aidna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
  end

  resource "oauthlib" do
    url "https:files.pythonhosted.orgpackages6dfafbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "parsedatetime" do
    url "https:files.pythonhosted.orgpackagesa820cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312acparsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "proto-plus" do
    url "https:files.pythonhosted.orgpackages3efce9a65cd52c1330d8d23af6013651a0bc50b6d76bcbdf91fae7cd19c68f29proto-plus-1.24.0.tar.gz"
    sha256 "30b72a5ecafe4406b0d339db35b56c4059064e69227b8c3bda7462397f966445"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackages5fd7331ee1f3b798c34d2257c79d5426ecbe95d46d2b40ba808a29da6947f6d8protobuf-5.28.0.tar.gz"
    sha256 "dde74af0fa774fa98892209992295adbfb91da3fa98c8f67a88afe8f5a349add"
  end

  resource "pyasn1" do
    url "https:files.pythonhosted.orgpackages4aa3d2157f333900747f20984553aca98008b6dc843eb62f3a36030140ccec0dpyasn1-0.6.0.tar.gz"
    sha256 "3a35ab2c4b5ef98e17dfdec8ab074046fbda76e281c5a706ccd82328cfc8f64c"
  end

  resource "pyasn1-modules" do
    url "https:files.pythonhosted.orgpackagesf700e7bd1dec10667e3f2be602686537969a7ac92b0a7c5165be2e5875dc3971pyasn1_modules-0.4.0.tar.gz"
    sha256 "831dbcea1b177b28c9baddf4c6d1013c24c3accd14a1873fffaa6a2e905f17b6"
  end

  resource "pyparsing" do
    url "https:files.pythonhosted.orgpackages830813f3bce01b2061f2bbd582c9df82723de943784cf719a35ac886c652043apyparsing-3.1.4.tar.gz"
    sha256 "f86ec8d1a83f11977c9a6ea7598e8c27fc5cddfa5b07ea2241edbbde1d7bc032"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-oauthlib" do
    url "https:files.pythonhosted.orgpackages42f205f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "rsa" do
    url "https:files.pythonhosted.orgpackagesaa657d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "types-httplib2" do
    url "https:files.pythonhosted.orgpackages7c3db26ad300bd4e14749aa09845aa7e24694d89f3184e76423777b2d9adf62ftypes-httplib2-0.22.0.20240310.tar.gz"
    sha256 "1eda99fea18ec8a1dc1a725ead35b889d0836fec1b11ae6f1fe05440724c1d15"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackages2311aae06ddb6a90cf8ba078be6dbe47f904d2efdf451f9859248b436c945ca4types-python-dateutil-2.9.0.20240821.tar.gz"
    sha256 "9649d1dcb6fef1046fb18bebe9ea2aa0028b160918518c34589a46045f6ebd98"
  end

  resource "types-requests" do
    url "https:files.pythonhosted.orgpackages5e9e7663eb27c33568b8fc20ccdaf2a1ce53a9530c42a7cceb9f552a6ff4a1d8types-requests-2.32.0.20240712.tar.gz"
    sha256 "90c079ff05e549f6bf50e02e910210b98b8ff1ebdd18e19c873cd237737c1358"
  end

  resource "types-vobject" do
    url "https:files.pythonhosted.orgpackagesbe43d8d88f126a7e1d5831c8af7dc81f31e3fa8af6c17799ca9ee0a14e674a74types-vobject-0.9.8.20240310.tar.gz"
    sha256 "36ed5266f9ecf593c49a45162f47ff881d125bc5a3ed5f3975af02f7c17bcc1f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "uritemplate" do
    url "https:files.pythonhosted.orgpackagesd25a4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000ebauritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}gcalcli refresh 2>&1", 2)
    assert_match "invalid choice: 'refresh'", output

    output = shell_output("#{bin}gcalcli --version")
    assert_match version.to_s, output
  end
end