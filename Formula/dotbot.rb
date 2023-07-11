class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https://github.com/anishathalye/dotbot"
  url "https://files.pythonhosted.org/packages/17/dd/e63106d944dfac3d2092ec5935c69f73ac806138586df719b3ce72027066/dotbot-1.19.2.tar.gz"
  sha256 "ae4e232fd47085a647826589d1c5bf2bf426c04f777365dc7e1e0626cdac2f01"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79006ccdd696063ce2cbee6ec1dd4a91d842409cadc108d28092321e75dee875"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8bdffd6a5bca42d174eeb3e7841022197c97afa037409c27983a97f30f9e7282"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c25024e47dbd3e1d884f404610ebf53c084e2185c7f07c88797458809b2ebcb2"
    sha256 cellar: :any_skip_relocation, ventura:        "b2407dc6cd7f2c311447a8b103493268e02b5e42150332deb65151d2a9994224"
    sha256 cellar: :any_skip_relocation, monterey:       "27406050db0bf0d3066eca4467c981b2a7cc452cfa0d2af50d43295c29e8a16d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7c2d3062329b363a839f6a5dd923a58c08f8867271ab622d425b20fb01881d99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23cf6f11a376a3a0e37e9a906d76e90469fd974d9c3def1f3a3a4532db79709a"
  end

  depends_on "python@3.11"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"install.conf.yaml").write <<~EOS
      - create:
        - brew
        - .brew/test
    EOS

    output = shell_output("#{bin}/dotbot -c #{testpath}/install.conf.yaml")
    assert_match "All tasks executed successfully", output
    assert_predicate testpath/"brew", :exist?
    assert_predicate testpath/".brew/test", :exist?
  end
end