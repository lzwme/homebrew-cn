class Mpremote < Formula
  include Language::Python::Virtualenv

  desc "Tool for interacting remotely with MicroPython devices"
  homepage "https://docs.micropython.org/en/latest/reference/mpremote.html"
  url "https://files.pythonhosted.org/packages/a1/f4/b63592bad49d61f0e79ca58d151eb914f1a3f716e606f436352ee5a1ff94/mpremote-1.26.0.tar.gz"
  sha256 "7f347318fb6d3bb8f89401d399a05efba39b51c74f747cebe92d3c6a9a4ee0b4"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "125b9c0e0eb17212f284b9fb4f7b747b420efbd21f97d10fc8b8bce35caebb45"
  end

  depends_on "python@3.13"

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/23/e8/21db9c9987b0e728855bd57bff6984f67952bea55d6f75e055c46b5383e8/platformdirs-4.4.0.tar.gz"
    sha256 "ca753cf4d81dc309bc67b0ea38fd15dc97bc30ce419a7f58d13eb3bf14c4febf"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mpremote --version")
    assert_match "no device found", shell_output("#{bin}/mpremote soft-reset 2>&1", 1)
  end
end