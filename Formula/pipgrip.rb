class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/0b/29/dc14d06cf107c2775108fc995caf700969a7395b26d739ab774bb4d4376c/pipgrip-0.10.6.tar.gz"
  sha256 "70db48889bbe31c8866264f42e7d553b33d638e76654d0b6fe151a83990db831"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c00619097aa338ff32737523b108d903c09e49021f9e929c39849c29b908c048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6180ad491d02d028fb97ccde282caeb0dbb71e1871384659df13164849e3ecde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f0b6ee612f07395b829ee0da6f6f8172bc31d05e4b27284dae1c6a938a75cbd"
    sha256 cellar: :any_skip_relocation, ventura:        "62f554503432dc2b608a0ea7d68cb5fe36bc80e2b97942844525d56d075e0632"
    sha256 cellar: :any_skip_relocation, monterey:       "f0bff7baa97083b8d1cf0fe382fb45e34d9c0bceb84eb8cc21bb78291d9bc582"
    sha256 cellar: :any_skip_relocation, big_sur:        "89b22cd6e2c7cd6dc56f208594d9fa628c399f12c6b2ea3f9f663f30fc08eb2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e5a31e09669c67fbcb91617f1308b5ce0f23d57b8cbcb91785bc2a0b773e7e7"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/ed/20/560b2c0801762f3de73ce04dd20d50ec39c2cdae83f23b6ed81cc72c7558/anytree-2.9.0.tar.gz"
    sha256 "06f7bc294293da2755f4699cc5da5c92d9182a5cfae2842c83fb56f02bd427c8"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c9/3d/02a14af2b413d7abf856083f327744d286f4468365cddace393a43d9d540/wheel-0.41.1.tar.gz"
    sha256 "12b911f083e876e10c595779709f8a88a59f45aacc646492a67fe9ef796c1b47"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end