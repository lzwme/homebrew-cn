class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://ghproxy.com/https://github.com/openSUSE/osc/archive/1.1.4.tar.gz"
  sha256 "8407ccdcaa6089601e3b9f42c03c015d938ba756b1553f65e2eb122ff00b83e5"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "5f95db9e0bacbba66365298534b3d9b8dca828951491e696dfc3cfe2e05c6b53"
    sha256 cellar: :any,                 arm64_monterey: "5d74d13509751d2afa523a0b877640d3571ece3aa51548acfd747be04eee3b48"
    sha256 cellar: :any,                 arm64_big_sur:  "abca1de1666f8666f015fe52f9d799858c46a097277b55e04fbbad02ac520624"
    sha256 cellar: :any,                 ventura:        "1b032300e00b2f226b5f03b8c250021b5f5a8238bfca56fa2dbd89f381dcea20"
    sha256 cellar: :any,                 monterey:       "5877638d219b074c0454dce3b53ceae50d6aa89ee82cb703ae298307cf34f96a"
    sha256 cellar: :any,                 big_sur:        "0e55111666f1bb6c050bb6bf15de071804f13bcdffade38d6f60be9623907ed3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7b9cf189ea722f18048c130d6f054d6702d5afb552c909b161f6164461430b6"
  end

  # `pkg-config` and `rust` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
    sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
  end

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

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