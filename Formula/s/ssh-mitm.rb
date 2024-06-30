class SshMitm < Formula
  include Language::Python::Virtualenv

  desc "SSH server for security audits and malware analysis"
  homepage "https:docs.ssh-mitm.at"
  url "https:files.pythonhosted.orgpackages6522d5a7a153b1f40f31e1a7e15439e4e3a2aad1413a486aa69c2f0be6482295ssh_mitm-5.0.0.tar.gz"
  sha256 "0c3ad0e925c7144e1c95efa08ab183100fcb8257068ae0729fb19493e3a45d60"
  license "GPL-3.0-only"
  head "https:github.comssh-mitmssh-mitm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "722a60ab7fcd6cdbcc3ba29a067304e66306af5a1d87de5afc79cf4e4af72a93"
    sha256 cellar: :any,                 arm64_ventura:  "a4834ee93be116d369a188e600acc62828dcd306c04886744995772c40a04856"
    sha256 cellar: :any,                 arm64_monterey: "24fb7a1aad5101c8fe658946784e993c5b74c15e3190bcf0967f7bb899f4ff22"
    sha256 cellar: :any,                 sonoma:         "004e3734922556ab3ca40a8db7e001c89800b5947e2d83a8c2e40505117f5ef6"
    sha256 cellar: :any,                 ventura:        "83173613228d9c215db78c1ecd4b483479a553c28aa8bd62fb44793b31200518"
    sha256 cellar: :any,                 monterey:       "036d65710f50c5e9100d63a650341738037c342a747d37ddf2eb3934c3011144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eaa3f4c2a45ce10353f7bebac84ad9fc58200dcf160af189d7ac83c996a17f6c"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "appimage" do
    url "https:files.pythonhosted.orgpackages5830625bf3d9cbb7b8736ea053b725bf72e55415cbe5ce4bf4c8971537fb5720appimage-1.0.0.tar.gz"
    sha256 "75933b9df5cd77dcdc8187fda3142dd84ea63ffc40712369ecc19652ea1ef3ac"
  end

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackagesdbca45176b8362eb06b68f946c2bf1184b92fc98d739a3f8c790999a257db91fargcomplete-3.4.0.tar.gz"
    sha256 "c2abcdfe1be8ace47ba777d4fce319eb13bf8ad9dace8d085dcad6eded88057f"
  end

  resource "bcrypt" do
    url "https:files.pythonhosted.orgpackagescae90b36987abbcd8c9210c7b86673d88ff0a481b4610630710fb80ba5661356bcrypt-4.1.3.tar.gz"
    sha256 "2ee15dd749f5952fe3f0430d0ff6b74082e159c50332a1413d51b5689cf06623"
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
    url "https:files.pythonhosted.orgpackagesccaf11996c4df4f9caff87997ad2d3fd8825078c277d6a928446d2b6cf249889paramiko-3.4.0.tar.gz"
    sha256 "aac08f26a31dc4dffd92821527d1682d99d52f9ef6851968114a8728f3c274d3"
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
    url "https:files.pythonhosted.orgpackages90269f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
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
    virtualenv_install_with_resources
  end

  test do
    require "pty"
    port = free_port

    stdout, _stdin, _pid = PTY.spawn("#{bin}ssh-mitm server --listen-port #{port}")
    assert_match "SSH-MITM - ssh audits made simple", stdout.readline
  end
end