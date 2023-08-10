class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/d9/f4/4f9efdc49097bcec4bc138ea0d55fff1db6ad54b032441ec4c0a78fc8982/pipgrip-0.10.5.tar.gz"
  sha256 "dba22c035439ee7942ff2989c33de7ce5247519dcef81bd9dd5042d3b35db3d3"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1eea05acf749f02e7c639a0ad3b1cf1c20e5989c2c6d0ff7afa2f95f69f3c46e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "465a49ff77e33caf18f40ad807414bd7a67a648d47171294d43abc06b8a5d033"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4575fb518d50366fe2972572bd648bddd69a81711caa2fe5df0e3acb56067db"
    sha256 cellar: :any_skip_relocation, ventura:        "9c71427a1cfa324632e25adf150c0f6d7b7d136a82e175ab97a306d93a7ea638"
    sha256 cellar: :any_skip_relocation, monterey:       "0fb7aa08a1e3a442f8fb66559b5c75a2066ed0138c3dfb2b060f7ee1267a3c15"
    sha256 cellar: :any_skip_relocation, big_sur:        "1669c1f65a13eaf351b147eee96323d2fe177fca403f89af61f7e668e2685dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e61c1121d0dc48e4f893b9df4d7ba2596e66c5c18f171c05afb84458c85fb1a7"
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

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/23/3f/f2251c754073cda0f00043a707cba7db103654722a9afed965240a0b2b43/pkginfo-1.7.1.tar.gz"
    sha256 "e7432f81d08adec7297633191bbf0bd47faf13cd8724c3a13250e51d542635bd"
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