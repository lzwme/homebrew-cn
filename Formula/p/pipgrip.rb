class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/5c/f9/3523793032c85a569da1c029f05ec89cefc473474b7ea7d3cf06a433558d/pipgrip-0.10.8.tar.gz"
  sha256 "84c7d7023474c6a3fcf08d43f8a28d3b2dc2c9d81a9fe9cbf1247bd40678fe76"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08d693c27f90589a5614e9d82e53a8e8e1163c877dffa28e6e2027f2fe7dcd17"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8bda2f9852be0a8324d1706c4f3d2ea8b428933df19f44ef92c2583983c14b22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ed0ac45ad1ddcf23d90a8890b2647a6e1e74f9006e1623e650d932f846e9b96"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e555fdcd75ef4845ae861541658dd0128364f5a554d4156b9de562fd1511f5f"
    sha256 cellar: :any_skip_relocation, ventura:        "5d3102bf1d5ac137053c4f7e7d1a7c87dc8bdb6944b768b83d7786a10be1c179"
    sha256 cellar: :any_skip_relocation, monterey:       "05edf47176785dae1e022b2b1730affc79c53aef82b7b4b41a750ecc7181566c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bacfe548e11757571b41431d301ee7ba95d69791ca7aa17506d97d68d6493b1b"
  end

  depends_on "python-click"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/7e/84/51e270f1f117da92025427e5cddd71ee62fc65de8b0391568055eb872d3d/anytree-2.12.0.tar.gz"
    sha256 "0dde0365cc8b1f3531e927694f39b903c360eadab2be09c50f3426ecca967949"
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