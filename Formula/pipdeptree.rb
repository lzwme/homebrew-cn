class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/97/db/2eb166d9861d26142d021b6a7f4cc85722e15cb022de1ac4914206cb90eb/pipdeptree-2.9.4.tar.gz"
  sha256 "e2ee93944e7cdf7107a461fb71738042aed8fd7950a254c7ee6bf6ec3f97aae9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b291c2cbd16d01e65f8eb76c43d18ebb68a5bc13f04b9a29e4be6df49e3eafe1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e291543c59698aead47336ce56860b3d3e3a10efabf01454d2ecb323dfbd7a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a90ce23013aaa5ad3f581bfcb2bd5f232c417387011fcc673389d75fd64862bf"
    sha256 cellar: :any_skip_relocation, ventura:        "3fb97bdaa15f01c235e02fdffe631166a69872310bcdac58790eb27da8c10542"
    sha256 cellar: :any_skip_relocation, monterey:       "3728e7566f61197402c15e55cfd1ed4102e1e69f9bd9e97be67451ba4de621cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fd8aad1ca823f0012de3a7483d056ec2166a5ef7a23876a25f4138860a0d7d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f329efc8cc64180c135ab98d10b1bb68ce7e00fa8dd7994b4df7c3cb445088fc"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end