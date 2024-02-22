class Abi3audit < Formula
  include Language::Python::Virtualenv

  desc "Scans Python packages for abi3 violations and inconsistencies"
  homepage "https:github.comtrailofbitsabi3audit"
  url "https:files.pythonhosted.orgpackagesa34d1f08c6db0b6cf02ef0fe33be39144d4477030910c3f61bffa3b2a9b09e87abi3audit-0.0.9.tar.gz"
  sha256 "4f469e146d911f238724d49fd280d8bb7f411ff5d224865b13e47d4132e776a6"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b4e194e73d865a9205cab4a4b0625b5838f13eebaca3ae73fe8fa5367f27a1b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f33987e9272b310d5f6d094d6a48496ebc573b3a06a161ced04ea818d7726b97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a684c47a323d7c2db7787fb63ee7c6a02f71bb1fa7cf706892e92cb52b1e61a"
    sha256 cellar: :any_skip_relocation, sonoma:         "2344f08d4891656340143cfeb40425a2559d5064f4d54dc8f5d675dea6c3df34"
    sha256 cellar: :any_skip_relocation, ventura:        "a9960efb58af7c475c26cdae7955c2c6ae3b1ebaa9a43b7df106f4151ba535a3"
    sha256 cellar: :any_skip_relocation, monterey:       "e52c01aa1845d8e306b81ed275a7bccdd46ab6f9d846b6a3e312bc9e00169368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dc4029dc11a715a681fe0603ac06e35feb1ca3af7eaa53713650742868a2534"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "rust" => :build
  end

  resource "abi3info" do
    url "https:files.pythonhosted.orgpackages6992b5d80a755641cf31ba72cbe4bfafbd73bbf22b2957f4c7dc59c124a48b4dabi3info-2024.2.3.post1.tar.gz"
    sha256 "81bad5e4213c4981edb0365381c0022ec44e5a39620413ca13f226cf6e2eab3f"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "cattrs" do
    url "https:files.pythonhosted.orgpackages1e57c6ccd22658c4bcb3beb3f1c262e1f170cf136e913b122763d0ddd328d284cattrs-23.2.3.tar.gz"
    sha256 "a934090d95abaa9e911dac357e3a8699e0b4b14f8529bcc7d2b1ad9d51672b9f"
  end

  resource "certifi" do
    url "https:files.pythonhosted.orgpackages71dae94e26401b62acd6d91df2b52954aceb7f561743aa5ccc32152886c76c96certifi-2024.2.2.tar.gz"
    sha256 "0569859f95fc761b18b45ef421b1290a0f65f147e92a1e5eb3e635f9a5e4e66f"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "kaitaistruct" do
    url "https:files.pythonhosted.orgpackages5404dd60b9cb65d580ef6cb6eaee975ad1bdd22d46a3f51b07a1e0606710ea88kaitaistruct-0.10.tar.gz"
    sha256 "a044dee29173d6afbacf27bcac39daf89b654dd418cfa009ab82d9178a9ae52a"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pefile" do
    url "https:files.pythonhosted.orgpackages78c53b3c62223f72e2360737fd2a57c30e5b2adecd85e70276879609a7403334pefile-2023.2.7.tar.gz"
    sha256 "82e6114004b3d6911c77c3953e3838654b04511b8b66e8583db70c65998017dc"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages96dcc1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackages8405fd41cd647de044d1ffec90ce5aaae935126ac217f8ecb302186655284fc8pyelftools-0.30.tar.gz"
    sha256 "2fc92b0d534f8b081f58c7c370967379123d8e00984deb53c209364efd575b40"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-cache" do
    url "https:files.pythonhosted.orgpackages4db624aeda90d94fb1fd2cd755d6ce176e526ef61d407f87fd77de6ab0d03157requests_cache-1.1.1.tar.gz"
    sha256 "764f93d3fa860be72125a568c2cc8eafb151cf29b4dc2515433a56ee657e1c60"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb10ee5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "url-normalize" do
    url "https:files.pythonhosted.orgpackagesecea780a38c99fef750897158c0afb83b979def3b379aaac28b31538d24c4e8furl-normalize-1.4.3.tar.gz"
    sha256 "d23d3a070ac52a67b83a1c59a0e68f8608d1cd538783b401bc9de2c0fac999b2"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagese2ccabf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}abi3audit sip 2>&1", 1)
    assert_match(sip: \d+ extensions scanned; \d+ ABI version mismatches and \d+ ABI\s+violations found, output)
  end
end