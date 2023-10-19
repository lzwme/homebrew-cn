class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/ba/35/218a9340ea032fc402fee92acf487007311d47be5fc37824984e5d7eb83f/pipgrip-0.10.7.tar.gz"
  sha256 "4bbd2f83ad4da7df2c10a58da618bfba5ca411f8964934251b18ce8a2e70a07c"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "56324ac6bbaaf8bee46f5abcf9f37e7ba11f9945ecd1278c3a112069b76db39c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60eea85cd7d84c757819573be75e2b0277f471e64e73ac6eeffeac684ec46167"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5002709ab2f4aacd9d4696a5a4e17d67afe9fd60cfd96144573bffadb5b6640d"
    sha256 cellar: :any_skip_relocation, sonoma:         "cada845e8cc77e3e5e0d5fb7c39f1f80ad4fd55eee605e6526b2993c86b313b1"
    sha256 cellar: :any_skip_relocation, ventura:        "380319e4c76613a16951bb6be5654f529561529f4f6a23cc3cb01302d138c7cb"
    sha256 cellar: :any_skip_relocation, monterey:       "ef3fb31c8a10580b8cd471a890b11400f44ac44583038913a4572a5d04ff3f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b15fdd980e02e0f64077546f3ffa629f8728a70983fd39d7c545cb912660af2"
  end

  depends_on "python-click"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/45/66/29b55cc478fb15b8d50e63f4d7465d3123437369c0e6b86451d8739475cd/anytree-2.10.0.tar.gz"
    sha256 "a5e922bef6bb5a154f8d306d37b40ea21885e4143856a9206a14b791cfc26102"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/a4/99/78c4f3bd50619d772168bec6a0f34379b02c19c9cced0ed833ecd021fd0d/wheel-0.41.2.tar.gz"
    sha256 "0c5ac5ff2afb79ac23ab82bab027a0be7b5dbcf2e54dc50efe4bf507de1f7985"
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