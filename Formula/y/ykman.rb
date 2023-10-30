class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/e4/25/3a42efa20f10f7bcec116ee678c36fb9a58b8cc12699be9603f1378d6f17/yubikey_manager-5.2.1.tar.gz"
  sha256 "35c5aa83ac474fd2434c33267dc0e33d312b3969b108f885e533463af3fbe4e1"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1114a2fa7d4ff58ebcdfbd33683bfb3e45ab21a685336d13f3dd19776d63805b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b59a868935e8f1a4f549c5f4de8ba6a3d93a428323b84d5ef141d399ceea972"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4f4a6ea15fe8a1f03e83ccdc6b69bd1322ada76c7c58f888049d56e408e273d"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ea75c8ca9f3db5aa281d07ac9f86151e753b609f45270f3dfabf1f47f0af2b7"
    sha256 cellar: :any_skip_relocation, ventura:        "277f46b2ce0d20761f41b0acc68eefee3038fd4969b60523f4634c6f59aaf8e9"
    sha256 cellar: :any_skip_relocation, monterey:       "7ec58eab87a2767c03916f6160fb24206e7ef9f63d122e2d19f9cfb2e64ec199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41bc427d193a6a18049f2fadfbfc4df774e0f503718d14ed679a35facb2a645d"
  end

  depends_on "swig" => :build
  depends_on "cffi"
  depends_on "keyring"
  depends_on "pycparser"
  depends_on "python-click"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"
  uses_from_macos "pcsc-lite"

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/a7/0f/b9f940372e0baa5a44742012f1eef1563296569db030a422ef3ce287b0ac/fido2-1.1.2.tar.gz"
    sha256 "6110d913106f76199201b32d262b2857562cc46ba1d0b9c51fbce30dc936c573"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/cc/33/b7d115ccf1b594af18db7ca61a7b07192356be35c65dfcd1d5ef9b28dc0a/pyscard-2.0.7.tar.gz"
    sha256 "278054525fa75fbe8b10460d87edcd03a70ad94d688b11345e4739987f85c1bf"
  end

  def install
    # Fixes: smartcard/scard/helpers.c:28:22: fatal error: winscard.h: No such file or directory
    ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}/PCSC" if OS.linux?

    # Fix `ModuleNotFoundError` issue with `keyring``
    site_packages = Language::Python.site_packages("python3.12")
    keyring_site_packages = Formula["keyring"].opt_libexec/site_packages
    ENV.prepend_path "PYTHONPATH", keyring_site_packages

    virtualenv_install_with_resources
    man1.install "man/ykman.1"

    (libexec/site_packages/"homebrew-keyring.pth").write keyring_site_packages

    # Click doesn't support generating completions for Bash versions older than 4.4
    generate_completions_from_executable(bin/"ykman", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end