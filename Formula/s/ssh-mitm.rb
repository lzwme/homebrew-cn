class SshMitm < Formula
  include Language::Python::Virtualenv

  desc "SSH server for security audits and malware analysis"
  homepage "https://docs.ssh-mitm.at"
  url "https://files.pythonhosted.org/packages/67/82/04ab95eec9ffb4afe510414d157b9f71548f96053a5d8bfd3822a5f281a8/ssh_mitm-4.0.0.tar.gz"
  sha256 "56d675aea4d94a2acff2c3902c405f8d958a24455fd9811fe479edb17220a655"
  license "GPL-3.0-only"
  head "https://github.com/ssh-mitm/ssh-mitm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6b4d89498127d5f25b3fc9b47e9d51598f187a5d0954764c10c30f93809e4df2"
    sha256 cellar: :any,                 arm64_ventura:  "64a772d3ad46bf33bf0e985773e0267bc1f984afc7c80a9ea00222f601b8ef93"
    sha256 cellar: :any,                 arm64_monterey: "4c30291fc623462564124c84fd7caaebe854b8da75e56cc9060e4ce314f66a28"
    sha256 cellar: :any,                 sonoma:         "960c5f20d900e5dbd6be455116d91ec16b7572aec0db573d1363b261e397cacf"
    sha256 cellar: :any,                 ventura:        "dba5000c881e039c4629bad03894a765e0c476c499346e43f8b68a915ba66a41"
    sha256 cellar: :any,                 monterey:       "0f69c0652dfb47bf0be8f3eecc8a4176122e1c799e492c4171654aa3749abb0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "250d4f0a85c3a268e7b9d8aa72b78714588743fa514c467faf525d4fc124f66c"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-argcomplete"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "colored" do
    url "https://files.pythonhosted.org/packages/d2/ce/cca52eb08fdb44fd99e0dd16de52228cb4ef108d7aff7c3bc359bc9b103c/colored-2.2.3.tar.gz"
    sha256 "1905ae45fa2b7fd63a8b4776586e63aeaba4df8db225b72b78fd167408558983"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/e8/53/e614a5b7bcc658d20e6eff6ae068863becb06bf362c2f135f5c290d8e6a2/paramiko-3.1.0.tar.gz"
    sha256 "6950faca6819acd3219d4ae694a23c7a87ee38d084f70c1724b0c0dbb8b75769"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/4f/da/95963cebfc578dabd323d7263958dfb68898617912bb09327dd30e9c8d13/python-json-logger-2.0.7.tar.gz"
    sha256 "23e7ec02d34237c5aa1e29a070193a4ea87583bb4e7f8fd06d3de8264c4b2e1c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b1/0e/e5aa3ab6857a16dadac7a970b2e1af21ddf23f03c99248db2c01082090a3/rich-13.6.0.tar.gz"
    sha256 "5c14d22737e6d5084ef4771b62d5d4363165b403455a30a1c8ca39dc7b644bef"
  end

  resource "sshpubkeys" do
    url "https://files.pythonhosted.org/packages/a3/b9/e5b76b4089007dcbe9a7e71b1976d3c0f27e7110a95a13daf9620856c220/sshpubkeys-3.3.1.tar.gz"
    sha256 "3020ed4f8c846849299370fbe98ff4157b0ccc1accec105e07cfa9ae4bb55064"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "pty"
    port = free_port

    stdout, _stdin, _pid = PTY.spawn("#{bin}/ssh-mitm server --listen-port #{port}")
    assert_match "SSH-MITM - ssh audits made simple", stdout.readline
  end
end