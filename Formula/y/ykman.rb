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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89da2a453d08f3552317a27119baad1dab9c00b899df8266eaed03139f05fd63"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2deeeb5eb977a97385b8564c08973657956c199815c8c7c25d29ad60e9506998"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b10384b3b74a506c8bc93ed17c332dee8db7ea1d61fbfd6bfba7c678425cd632"
    sha256 cellar: :any_skip_relocation, sonoma:         "601c14c67869da05aabf9d73175ce156b058adcf338a1c7a247b9e6606f8e4ee"
    sha256 cellar: :any_skip_relocation, ventura:        "cd78402635fdd416ac30bdbe09ac540b82e544decc3f9c106301239706b1c874"
    sha256 cellar: :any_skip_relocation, monterey:       "60451616f7314c6c8ba51258c7db0e22dfa71646cbbe2aad7cbb64b72e633c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3536a90f7bd24df38b78797032fd514cb4e942ee845416abd69956a08b5b77fd"
  end

  depends_on "swig" => :build
  depends_on "cffi"
  depends_on "keyring"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "libffi"
  uses_from_macos "pcsc-lite"

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

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