class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/38/e0/b0d4e6a7c048ee8490d21a3c942bdffd6cee3e71dd5be8f33c944312c8a2/git-cola-4.2.0.tar.gz"
  sha256 "76be2e0fae4e64612ab30adff7f53bc687ab92fb3498e90f54c0301f2135a5c0"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3872c4329b353377812c00bc646af9b95fa8a796f30150621910f25a9735830f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b26d15292702ac4a2e5cfb8d6782072cd32b8018c5b901669cee12d9a365a7dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55539ea1e4b618719a3dcc2354cd4c7088141506147ca521c1a31174ce160568"
    sha256 cellar: :any_skip_relocation, ventura:        "758d5019351d128add6448cef17adf15414e152270b5c6ecb14240d56307b22b"
    sha256 cellar: :any_skip_relocation, monterey:       "28d3e5d1c946d855bfd1418e244f97e760de9fd304811a4c833d5086a83a0ebb"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bc48bb7e6525726214f70eb845292cdf0661000564f8fdaeb26652b9e087381"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c170286a39159598b84cea097ee7de82e6e123d3f5101cce8f0869b33c946105"
  end

  depends_on "pyqt@5"
  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "QtPy" do
    url "https://files.pythonhosted.org/packages/b0/96/4f3be023cee0261b1f6cd5d2f6c2a5abea8d8022fc66027da8792373a57e/QtPy-2.3.0.tar.gz"
    sha256 "0603c9c83ccc035a4717a12908bf6bc6cb22509827ea2ec0e94c2da7c9ed57c5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end