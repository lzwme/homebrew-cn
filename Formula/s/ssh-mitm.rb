class SshMitm < Formula
  include Language::Python::Virtualenv

  desc "SSH server for security audits and malware analysis"
  homepage "https:docs.ssh-mitm.at"
  url "https:files.pythonhosted.orgpackages6522d5a7a153b1f40f31e1a7e15439e4e3a2aad1413a486aa69c2f0be6482295ssh_mitm-5.0.0.tar.gz"
  sha256 "0c3ad0e925c7144e1c95efa08ab183100fcb8257068ae0729fb19493e3a45d60"
  license "GPL-3.0-only"
  revision 1
  head "https:github.comssh-mitmssh-mitm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "043c5dd939bff192cceab387771d00d44aa9c1156604dc6cec597fdfa93e3351"
    sha256 cellar: :any,                 arm64_sonoma:  "e5467dee9666148cb0ff3e9082af11167fad3d0ee93fc53cdcf932d763a10ca9"
    sha256 cellar: :any,                 arm64_ventura: "ef8c81c52e041f0eeeead3cc39020ed1c366ff99766e5c40d7a8d829fcb989bb"
    sha256 cellar: :any,                 sonoma:        "29dfca7957e1fe8d9b497e78ae338b03af2350b2cc7339698b4501e39332826b"
    sha256 cellar: :any,                 ventura:       "44562ad8c9b8a789d10fd58e7e39ac12a38491034a662442252d322cf42ad27e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f04102f106aca16ca4039b68f6c505c3c8f8e2a0b701fe24b130cd52c05eab42"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cryptography"
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "appimage" do
    url "https:files.pythonhosted.orgpackages5830625bf3d9cbb7b8736ea053b725bf72e55415cbe5ce4bf4c8971537fb5720appimage-1.0.0.tar.gz"
    sha256 "75933b9df5cd77dcdc8187fda3142dd84ea63ffc40712369ecc19652ea1ef3ac"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7f03581b1c29d88fffaa08abbced2e628c34dd92d32f1adaed7e42fc416938b0argcomplete-3.5.2.tar.gz"
    sha256 "23146ed7ac4403b70bd6026402468942ceba34a6732255b9edf5b7354f68a6bb"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagese47ed95e7d96d4828e965891af92e43b52a4cd3395dc1c1ef4ee62748d0471d0bcrypt-4.2.0.tar.gz"
    sha256 "cf69eaf5185fd58f268f805b505ce31f9b9fc2d64b376642164e9244540c1221"
  end

  resource "colored" do
    url "https:files.pythonhosted.orgpackages2f984d4546307039955eec131cf9538732fb7a28d2db2090cd1d4e4a135829e1colored-2.2.4.tar.gz"
    sha256 "595e1dd7f3b472ea5f12af21d2fec8a2ea2cf8f9d93e67180197330b26df9b61"
  end

  resource "ecdsa" do
    url "https:files.pythonhosted.orgpackages5ed0ec8ac1de7accdcf18cfe468653ef00afd2f609faf67c423efbd02491051becdsa-0.19.0.tar.gz"
    sha256 "60eaad1199659900dd0af521ed462b793bbdf867432b3948e87416ae4caf6bf8"
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

  resource "paramiko" do
    url "https:files.pythonhosted.orgpackages0b6a1d85cc9f5eaf49a769c7128039074bbb8127aba70756f05dfcf4326e72a1paramiko-3.4.1.tar.gz"
    sha256 "8b15302870af7f6652f2e038975c1d2973f06046cb5d7d65355668b3ecbece0c"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-json-logger" do
    url "https:files.pythonhosted.orgpackages4fda95963cebfc578dabd323d7263958dfb68898617912bb09327dd30e9c8d13python-json-logger-2.0.7.tar.gz"
    sha256 "23e7ec02d34237c5aa1e29a070193a4ea87583bb4e7f8fd06d3de8264c4b2e1c"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages3a313c70bf7603cc2dca0f19bdc53b4537a797747a58875b552c8c413d963a3fpytz-2024.2.tar.gz"
    sha256 "2aa355083c50a0f93fa581709deac0c9ad65cca8a9e9beac660adcbd493c798a"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesaa9e1784d15b057b0075e5136445aaea92d23955aad2c93eaede673718a40d95rich-13.9.2.tar.gz"
    sha256 "51a2c62057461aaf7152b4d611168f93a9fc73068f8ded2790f29fe2b5366d0c"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sshpubkeys" do
    url "https:files.pythonhosted.orgpackagesa3b9e5b76b4089007dcbe9a7e71b1976d3c0f27e7110a95a13daf9620856c220sshpubkeys-3.3.1.tar.gz"
    sha256 "3020ed4f8c846849299370fbe98ff4157b0ccc1accec105e07cfa9ae4bb55064"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  def install
    ENV["SODIUM_INSTALL"] = "system"
    virtualenv_install_with_resources
  end

  test do
    # supress CryptographyDeprecationWarning warning,
    # upstream bug report https:github.comssh-mitmssh-mitmissues177
    ENV["PYTHONWARNINGS"] = "ignore"

    require "pty"
    port = free_port

    stdout, _stdin, _pid = PTY.spawn("#{bin}ssh-mitm server --listen-port #{port}")
    assert_match "SSH-MITM - ssh audits made simple", stdout.readline
  end
end