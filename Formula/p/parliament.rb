class Parliament < Formula
  include Language::Python::Virtualenv

  desc "AWS IAM linting library"
  homepage "https:github.comduo-labsparliament"
  url "https:files.pythonhosted.orgpackages8e9a64e0e24972057276141403b5971e87d8f51c82ba3d027badc10f39e5524fparliament-1.6.2.tar.gz"
  sha256 "05f9db2bda8d85f039dbe27716538f025b7cb973d336568762a06217e3b7e3ae"
  license "BSD-3-Clause"
  revision 3
  head "https:github.comduo-labsparliament.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bce9bb9c34242b31af31e337ec4e921bf4f757a4a8ccbfdfcdb859187a367830"
    sha256 cellar: :any,                 arm64_ventura:  "07348851991c11092b1ad8cd2c00b0bb20272797a445e8a9799ecf887804d360"
    sha256 cellar: :any,                 arm64_monterey: "289ac9dccb2fd28c604da1d509381b09cc9400bcbfb28773ed414de236d51d74"
    sha256 cellar: :any,                 sonoma:         "13bdd2035761d5a6c20efa163b801e741aa0e9c2a359d9cde16307b0c72780f2"
    sha256 cellar: :any,                 ventura:        "1a7949913ee0783f75f58065774e6e35f9b7d068fd26beda33242ae2ecd65394"
    sha256 cellar: :any,                 monterey:       "da7b6e56678b97a6ddb9f92931d858dad81ba33b56bdd44f357d00a353d81e22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e1033132a4ff13024bb45183fefdd6d1501dff3839be1b1f9214c875f5363bf"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "boto3" do
    url "https:files.pythonhosted.orgpackages81f50c7d1b745462d9fe0c2b4709dc6a4b1cbe399c02ad60b26ae2837714d455boto3-1.34.128.tar.gz"
    sha256 "43a6e99f53a8d34b3b4dbe424dbcc6b894350dc41a85b0af7c7bc24a7ec2cead"
  end

  resource "botocore" do
    url "https:files.pythonhosted.orgpackages9ec9844ad5680d847d94adb97b22c30b938ddda86f8a815d439503d4ee545484botocore-1.34.128.tar.gz"
    sha256 "8d8e03f7c8c080ecafda72036eb3b482d649f8417c90b5dca33b7c2c47adb0c9"
  end

  resource "jmespath" do
    url "https:files.pythonhosted.orgpackages002ae867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "json-cfg" do
    url "https:files.pythonhosted.orgpackages70d834e37fb051be7c3b143bdb3cc5827cb52e60ee1014f4f18a190bb0237759json-cfg-0.4.2.tar.gz"
    sha256 "d3dd1ab30b16a3bb249b6eb35fcc42198f9656f33127e36a3fadb5e37f50d45b"
  end

  resource "kwonly-args" do
    url "https:files.pythonhosted.orgpackageseedaa7ba4f2153a536a895a9d29a222ee0f138d617862f9b982bd4ae33714308kwonly-args-1.0.10.tar.gz"
    sha256 "59c85e1fa626c0ead5438b64f10b53dda2459e0042ea24258c9dc2115979a598"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "s3transfer" do
    url "https:files.pythonhosted.orgpackages83bcfb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesaa605db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "MEDIUM - No resources match for the given action -  - [{'action': 's3:GetObject', " \
                 "'required_format': 'arn:*:s3:::**'}] - {'line': 1, 'column': 40, 'filepath': None}",
    pipe_output("#{bin}parliament --string '{\"Version\": \"2012-10-17\", \"Statement\": {\"Effect\": \"Allow\", " \
                "\"Action\": \"s3:GetObject\", \"Resource\": \"arn:aws:s3:::secretbucket\"}}'").strip
  end
end