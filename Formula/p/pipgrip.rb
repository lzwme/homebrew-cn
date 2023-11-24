class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/5b/ac/b9f4f4df6270d75202583407ddaef8651163127d228758e8418974f70b5a/pipgrip-0.10.10.tar.gz"
  sha256 "b8e947c79eef74100a5dc256a94d377205b3b00816e4195964a73ee28deb9a4d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a90cca68643dd574d05ac12ad8bab32fe35e44ea2ee7f03b6501980b5b4d948f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0805cdeab867487cb687c41111b47e15bdbe06e22d1165e22fb1095e8658e133"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53f76d2b8261aeaaaedef651933ec837caca270ebe99ec9d8cff6b6f19b0adde"
    sha256 cellar: :any_skip_relocation, sonoma:         "8a68902f3dd106a133650d517656d8e9baee6ba6eb42920b3dccdbbf866b43d5"
    sha256 cellar: :any_skip_relocation, ventura:        "6f3c075ef1cc11c51d009aea52705e242798b5b8bf051b01dcfce3882bdcc5c0"
    sha256 cellar: :any_skip_relocation, monterey:       "6cb489486187db1dfd3b8d2300922abbc26dec786d01a0b5c6eff1a0327a9ac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4d440684f8a867e112f6f164397cb217b637b822946b4f616091604b63bc9a8"
  end

  depends_on "python-click"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/f9/44/2dd9c5d0c3befe899738b930aa056e003b1441bfbf34aab8fce90b2b7dea/anytree-2.12.1.tar.gz"
    sha256 "244def434ccf31b668ed282954e5d315b4e066c4940b94aff4a7962d85947830"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fb/d0/0b4c18a0b85c20233b0c3bc33f792aefd7f12a5832b4da77419949ff6fd9/wheel-0.41.3.tar.gz"
    sha256 "4d4987ce51a49370ea65c0bfd2234e8ce80a12780820d9dc462597a6e60d0841"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pipgrip", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end