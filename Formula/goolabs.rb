class Goolabs < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for morphologically analyzing Japanese language"
  homepage "https://pypi.python.org/pypi/goolabs"
  url "https://files.pythonhosted.org/packages/ce/86/2d3b5bd85311ee3a7ae7a661b3619095431503cd0cae03048c646b700cad/goolabs-0.4.0.tar.gz"
  sha256 "4f768a5b98960c507f5ba4e1ca14d45e3139388669148a2750d415c312281527"
  license "MIT"
  revision 6

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07491c55a405e103578678ab43f4925febea8624fa3f64675a3606e6a60845c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca23a9f545848b5de84257b55b5eee4e039a2d702364c218a5258ad38979c6ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a29d8eb9dd0259f96e74bae26c5d07c86693949027e294d3cdeb4af2cf536ac5"
    sha256 cellar: :any_skip_relocation, ventura:        "2af708e99bd66dc651915f81bc107a1389c87bc085746f721dffd0afdecfb4b9"
    sha256 cellar: :any_skip_relocation, monterey:       "448faf5dd61a9634e912decebf9941b1bfdbc4ff8a2c0edc0da0b51eca6e79bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e23739c6303b72cd28449f05bd83a2bc33c894d3c3b0022c91f11d9f2416fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c31baa603f9fe53dbb80734be888d049b89b14ca3c8b4a60fd35d725fdfc6dd9"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage: goolabs morph", shell_output("#{bin}/goolabs morph test 2>&1", 2)
  end
end