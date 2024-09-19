class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https:github.comtox-devpipdeptree"
  url "https:files.pythonhosted.orgpackages66b6389a1148d7b1bc5638d4e9b2d60390f8cfb4c30e34cff68165cbd9a29e75pipdeptree-2.23.4.tar.gz"
  sha256 "8a9e7ceee623d1cb2839b6802c26dd40959d31ecaa1468d32616f7082658f135"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56ba118acd86e49a612e01f2c63d4287c9393585c7002377e6900aa724ab706a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56ba118acd86e49a612e01f2c63d4287c9393585c7002377e6900aa724ab706a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "56ba118acd86e49a612e01f2c63d4287c9393585c7002377e6900aa724ab706a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6df59735707bfd8fbc01fac5303639c4c11f12df31fa3ff90eb2c1269eb687a"
    sha256 cellar: :any_skip_relocation, ventura:       "d6df59735707bfd8fbc01fac5303639c4c11f12df31fa3ff90eb2c1269eb687a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56ba118acd86e49a612e01f2c63d4287c9393585c7002377e6900aa724ab706a"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}pipdeptree --all")

    assert_empty shell_output("#{bin}pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}pipdeptree --version").strip
  end
end