class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://ghproxy.com/https://github.com/openSUSE/osc/archive/1.2.0.tar.gz"
  sha256 "0b2b094a515b340f859b417016def33f9b33a47abe4c3fad66c5dbc8b8447a7d"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44bf0cc65646aec0ef635c261050b64ac912647613ea2b6d0fac83f84a4d10ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5fc477223f19949e46bc2d8b5a38b6094688bb239cf40cdd61bb24c0dd5b21d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc7d062c74a732c57eeec2247b84feb94398923293e4f8a5f351b9a8b115291c"
    sha256 cellar: :any_skip_relocation, ventura:        "ff2b0562ca031b8c9794d73776e8744c7b397e3d0dfa54d37d1dbfb6cc06eff3"
    sha256 cellar: :any_skip_relocation, monterey:       "df38102fc5468e4ab5f768cd0d30b2be82d9e60edd899e3cc3ac73e567b9e4b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "37cfd8d6b2f40dc39549b7a7bedf96e309d72169d86342efa958d2f1bb8a13d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6887b4e39ea6190daec6e1677f0c35ff4264c54285fcf44ac123f51b779f3066"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~EOS
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    EOS

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end