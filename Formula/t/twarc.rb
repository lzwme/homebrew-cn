class Twarc < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool and Python library for archiving Twitter JSON"
  homepage "https:github.comDocNowtwarc"
  url "https:files.pythonhosted.orgpackages8aedac80b24ece6ee552f6deb39be34f01491cff4018cca8c5602c901dc08ecftwarc-2.14.0.tar.gz"
  sha256 "fa8ee3052d8b9678231bea95d1bdcbabb3968d35c56a8d1fcedc8982e8c66a66"
  license "MIT"
  revision 3

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9a654287805d70c4c44d17e66dfee11f7af6c767fbfc597d1c41a78b4cb8af8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98ad2c73447bac792184fed348f1bf5d5a6139132d213897a73a59d7f70e6286"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54e9f1e8d55a1b1d895fefe3639458d07cbae175da0fed13f5ed993b7e55d8ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "ac47391d38dba1a6b0e46c07faee272eb237c40183ce6bf2980c1f94d4ecc2c0"
    sha256 cellar: :any_skip_relocation, ventura:        "e05ac2594c83cc5acc05838948ad0dec2191662bdb86c95e08bd05187be5680e"
    sha256 cellar: :any_skip_relocation, monterey:       "efba41e4e6a2d53ed5a6cc051692d84dbb32c939188847ec76df22323d23a185"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33dd392b334da9166966cb3515ac5b0bdc81db4d694bac9000abb7932bd178a2"
  end

  depends_on "python-click"
  depends_on "python-configobj"
  depends_on "python-dateutil"
  depends_on "python-requests"
  depends_on "python-requests-oauthlib"
  depends_on "python@3.12"
  depends_on "six"

  resource "click-config-file" do
    url "https:files.pythonhosted.orgpackages1309dfee76b0d2600ae8bd65e9cc375b6de62f6ad5600616a78ee6209a9f17f3click_config_file-0.6.0.tar.gz"
    sha256 "ded6ec1a73c41280727ec9c06031e929cdd8a5946bf0f99c0c3db3a71793d515"
  end

  resource "click-plugins" do
    url "https:files.pythonhosted.orgpackages5f1d45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "humanize" do
    url "https:files.pythonhosted.orgpackages76217a0b24fae849562397efd79da58e62437243ae0fd0f6c09c6bc26225b75chumanize-4.9.0.tar.gz"
    sha256 "582a265c931c683a7e9b8ed9559089dea7edcf6cc95be39a3cbc2c5d5ac2bcfa"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackages6206d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "usage: twarc [-h] [--log LOG] [--consumer_key CONSUMER_KEY]",
                 shell_output("#{bin}twarc -h").chomp.split("\n").first
  end
end