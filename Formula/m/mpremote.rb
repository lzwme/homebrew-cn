class Mpremote < Formula
  include Language::Python::Virtualenv

  desc "Tool for interacting remotely with MicroPython devices"
  homepage "https://docs.micropython.org/en/latest/reference/mpremote.html"
  url "https://files.pythonhosted.org/packages/a1/f4/b63592bad49d61f0e79ca58d151eb914f1a3f716e606f436352ee5a1ff94/mpremote-1.26.0.tar.gz"
  sha256 "7f347318fb6d3bb8f89401d399a05efba39b51c74f747cebe92d3c6a9a4ee0b4"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b12a460088c523aec51a337f3ff11978d2a06ba58800f5e2b902a39d88717c5a"
  end

  depends_on "python@3.13"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  def install
    virtualenv_install_with_resources

    # Build an `:all` bottle.
    usr_local_files = %W[
      platformdirs/unix.py
      platformdirs-#{resource("platformdirs").version}.dist-info/METADATA
    ].map { |file| libexec/Language::Python.site_packages("python3")/file }
    inreplace usr_local_files, "/usr/local", HOMEBREW_PREFIX

    opt_homebrew_files = %w[
      platformdirs/macos.py
    ].map { |file| libexec/Language::Python.site_packages("python3")/file }
    inreplace opt_homebrew_files, "/opt/homebrew", HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpremote --version")
    assert_match "no device found", shell_output("#{bin}/mpremote soft-reset 2>&1", 1)
  end
end