class Abi3audit < Formula
  include Language::Python::Virtualenv

  desc "Scans Python packages for abi3 violations and inconsistencies"
  homepage "https:github.comtrailofbitsabi3audit"
  url "https:files.pythonhosted.orgpackagesfb4fc81d13426d85491766affc93c08e7ee65e12f1e12202dd1874410f6ffeecabi3audit-0.0.11.tar.gz"
  sha256 "8f527908e4c1e90218b9a62958ed4124c7edc1ec115dc5ee019f92e5752a10b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d568160019e393e52165dfce2b57375a490bb4ac2ec36b5ade36110960028177"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d568160019e393e52165dfce2b57375a490bb4ac2ec36b5ade36110960028177"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d568160019e393e52165dfce2b57375a490bb4ac2ec36b5ade36110960028177"
    sha256 cellar: :any_skip_relocation, sonoma:         "4141b321818049efca92cc1271cbdd8dd12c6c882ccabecd7a5b5d792367618f"
    sha256 cellar: :any_skip_relocation, ventura:        "4141b321818049efca92cc1271cbdd8dd12c6c882ccabecd7a5b5d792367618f"
    sha256 cellar: :any_skip_relocation, monterey:       "4141b321818049efca92cc1271cbdd8dd12c6c882ccabecd7a5b5d792367618f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ed664174c09bbd14907e6787d6e104d50a86b5afd43f9f4e0a5239ec97bffef"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "rust" => :build
  end

  resource "abi3info" do
    url "https:files.pythonhosted.orgpackages3ba83223100090d37f36054159e761ab06694186ee32f6576b5dc4817d18921babi3info-2024.6.25.tar.gz"
    sha256 "e94bf88025c4bee77ebe0ff24a39b103dce646345de5e21f9fdfc8f9a00c1830"
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
    url "https:files.pythonhosted.orgpackagesc202a95f2b11e207f68bc64d7aae9666fed2e2b3f307748d5123dffb72a1bbeacertifi-2024.7.4.tar.gz"
    sha256 "5a1e7645bc0ec61a09e26c36f6106dd4cf40c6db3a1fb6352b0244e7fb057c7b"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
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
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pefile" do
    url "https:files.pythonhosted.orgpackages78c53b3c62223f72e2360737fd2a57c30e5b2adecd85e70276879609a7403334pefile-2023.2.7.tar.gz"
    sha256 "82e6114004b3d6911c77c3953e3838654b04511b8b66e8583db70c65998017dc"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesf5520763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackages88560f2d69ed9a0060da009f672ddec8a71c041d098a66f6b1d80264bf6bbdc0pyelftools-0.31.tar.gz"
    sha256 "c774416b10310156879443b81187d182d8d9ee499660380e645918b50bc88f99"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requests-cache" do
    url "https:files.pythonhosted.orgpackages1abe7b2a95a9e7a7c3e774e43d067c51244e61dea8b120ae2deff7089a93fb2brequests_cache-1.2.1.tar.gz"
    sha256 "68abc986fdc5b8d0911318fbb5f7c80eebcd4d01bfacc6685ecf8876052511d1"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
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
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}abi3audit sip 2>&1", 1)
    assert_match(sip: \d+ extensions scanned; \d+ ABI version mismatches and \d+ ABI\s+violations found, output)
  end
end