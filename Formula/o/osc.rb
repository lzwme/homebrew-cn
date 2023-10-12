class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://ghproxy.com/https://github.com/openSUSE/osc/archive/1.4.1.tar.gz"
  sha256 "33d0f33fce7f9d85c07d4dde320dc2a9d2e7de3e23b3810149cb9a821ab6834d"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "19e79fee03a1bded2fbd2d6f2fb5b0aa47c7c10fa9b2e17244be8d1ed40cf0d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6039ccf61e5a75f77b3f86af36caebb6365eaa8c5c45c15bb5972f6e3b53e10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18a5a33af2d437be6d473c4463500e261c6a6604cf2173e0c46da7ef976de0f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "54bd636fc96e5894d5f69f838ab9242350a09717e4b5708de5d7270fbc940f25"
    sha256 cellar: :any_skip_relocation, ventura:        "c42831eeca8f161e5969201c823df9fb02afc0c21556ff2784cf4c4183698dfa"
    sha256 cellar: :any_skip_relocation, monterey:       "1b9ec838ef22891cb6ca0a26cf56d0bd4f5e0115740c4def549dbf5ab661b41c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f5defe6bd36926ad8c4293706d84a1e8653d0a0451a64f8cbf079695a944427"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
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