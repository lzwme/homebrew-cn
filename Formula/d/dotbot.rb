class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https:github.comanishathalyedotbot"
  url "https:files.pythonhosted.orgpackages3d64753a02c8cd7451b7427b8639ed1defc7a3f0c4ab16f91b1676c8339007c7dotbot-1.22.0.tar.gz"
  sha256 "9927ccee53483b84fd3035593e470bdf313b3e77787e67663fdff7098786e6d9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "aed0b799fc07fcf7c87b8217a2312e16549542be0af8fd53e8849d67cea13e56"
    sha256 cellar: :any,                 arm64_sonoma:  "68a2d33f04bae44710a83be59d101f863ef67ec8a418d02f9dc7381d68841ff4"
    sha256 cellar: :any,                 arm64_ventura: "d6aafa42ce883a7cd3948972deb99cf9401a80f88a57e2d3a0b136cdce7228b1"
    sha256 cellar: :any,                 sonoma:        "b4dc841fb2ceefb3b52994f2d84f148fed734eb5cd5e8c648a0dbc225bc11411"
    sha256 cellar: :any,                 ventura:       "77ad31d5353d96a71b6301230aa647191d8fa8717bc7c679eb0e6dd57af327c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20f3c17f485723abc6724835d1f34dfe7000803fedd6567bd60aca1d37e17b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9be2d52555a8811e6639d73960c5569179ad95412265077e243df3834aa5788"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"install.conf.yaml").write <<~YAML
      - create:
        - brew
        - .brewtest
    YAML

    output = shell_output("#{bin}dotbot -c #{testpath}install.conf.yaml")
    assert_match "All tasks executed successfully", output
    assert_path_exists testpath"brew"
    assert_path_exists testpath".brewtest"
  end
end