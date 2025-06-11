class Abi3audit < Formula
  include Language::Python::Virtualenv

  desc "Scans Python packages for abi3 violations and inconsistencies"
  homepage "https:github.compypaabi3audit"
  url "https:files.pythonhosted.orgpackagesdf83c2ba9ad764c3f432651ce396468b99995fb3fe97c29f7549d1c3cfb05112abi3audit-0.0.21.tar.gz"
  sha256 "78f6155dfcf089657764bf194ddeac987111a5648eba54fcd6b486968db4d3fa"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45ce7434dde77dbdd1160b08b01232887574ece25942c963e1a3d4568ae1f3b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45ce7434dde77dbdd1160b08b01232887574ece25942c963e1a3d4568ae1f3b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "45ce7434dde77dbdd1160b08b01232887574ece25942c963e1a3d4568ae1f3b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "e729efcec694432e3b2040afde6d245fa5e64b94e4ba01c023b097ea1a3926d3"
    sha256 cellar: :any_skip_relocation, ventura:       "e729efcec694432e3b2040afde6d245fa5e64b94e4ba01c023b097ea1a3926d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97281f4d91d1221ed2f0806d4b314865a448226a922d65145e1609acee7b54c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97281f4d91d1221ed2f0806d4b314865a448226a922d65145e1609acee7b54c5"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13"

  on_linux do
    depends_on "rust" => :build
  end

  resource "abi3info" do
    url "https:files.pythonhosted.orgpackagesda48ec0cb606d072dbefd7d83930030f8ee499927bd11df213e53c76655b0367abi3info-2025.4.29.tar.gz"
    sha256 "00733a73532cbf6f41e78549dc959a2110fce6e33d207a31c1ec653fa4be3b20"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "cattrs" do
    url "https:files.pythonhosted.orgpackages572b561d78f488dcc303da4639e02021311728fb7fda8006dd2835550cddd9edcattrs-25.1.1.tar.gz"
    sha256 "c914b734e0f2d59e5b720d145ee010f1fd9a13ee93900922a2f3f9d593b8382c"
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
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pefile" do
    url "https:files.pythonhosted.orgpackages034f2750f7f6f025a1507cd3b7218691671eecfd0bbebebe8b39aa0fe1d360b8pefile-2024.8.26.tar.gz"
    sha256 "3ff6c5d8b43e8c37bb6e6dd5085658d658a7a0bdcd20b6a07b1fcfc1c4e9d632"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pyelftools" do
    url "https:files.pythonhosted.orgpackagesb9ab33968940b2deb3d92f5b146bc6d4009a5f95d1d06c148ea2f9ee965071afpyelftools-0.32.tar.gz"
    sha256 "6de90ee7b8263e740c8715a925382d4099b354f29ac48ea40d840cf7aa14ace5"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "requests-cache" do
    url "https:files.pythonhosted.orgpackages1abe7b2a95a9e7a7c3e774e43d067c51244e61dea8b120ae2deff7089a93fb2brequests_cache-1.2.1.tar.gz"
    sha256 "68abc986fdc5b8d0911318fbb5f7c80eebcd4d01bfacc6685ecf8876052511d1"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "url-normalize" do
    url "https:files.pythonhosted.orgpackages8031febb777441e5fcdaacb4522316bf2a527c44551430a4873b052d545e3279url_normalize-2.2.1.tar.gz"
    sha256 "74a540a3b6eba1d95bdc610c24f2c0141639f3ba903501e61a52a8730247ff37"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}abi3audit sip 2>&1", 1)
    assert_match(sip: \d+ extensions scanned; \d+ ABI version mismatches and \d+ ABI\s+violations found, output)
  end
end