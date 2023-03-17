class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://ghproxy.com/https://github.com/openSUSE/osc/archive/1.0.0.tar.gz"
  sha256 "7de363267803cbfdec4794da9da4491b18cd8b26dd94d6ab2071b80a24c14974"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3be25eae843651d13332d085dc4a7e7b23f7c0d2d31e0d70220f8af7d46f95d5"
    sha256 cellar: :any,                 arm64_monterey: "f40077a64ff1035659b8851de871eecc685296150fad942b336f3a5fe2bb3d00"
    sha256 cellar: :any,                 arm64_big_sur:  "51ac32869990765752db1249c84f615c62aebfa343b37314470af9bc258710bb"
    sha256 cellar: :any,                 ventura:        "1d1a55d907c73014304adfe05dd2228fdff4f74e45e3377976cc6827b78e4ea8"
    sha256 cellar: :any,                 monterey:       "c9e42c21e657282f94d3de3cbdf7d5d32c32dbb99c4b0ec41f46a164a4a80b51"
    sha256 cellar: :any,                 big_sur:        "0d0559948754c8568ed410847210ef71b929bdf2f9cb80453af1ee91470bfcd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76e52514a9887f9172af7b20365b01c48edbcc08455a8acc0afac9978abd76d9"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "cffi"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/fa/f3/f4b8c175ea9a1de650b0085858059050b7953a93d66c97ed89b93b232996/cryptography-39.0.2.tar.gz"
    sha256 "bc5b871e977c8ee5a1bbc42fa8d19bcc08baf0c51cbf1586b0e87a2694dde42f"
  end

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
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