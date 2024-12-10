class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https:github.comanishathalyedotbot"
  url "https:files.pythonhosted.orgpackagesf967793d72c813a4781227963f77d353db4830760ed9a40a5752330f2d7c10d9dotbot-1.20.3.tar.gz"
  sha256 "6c4ec52e498964082e1048a26f9b1e5fcebe0b384f8b3cefb90525c2d8c70030"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "87b5108bab956ad08c11dfee17a4c30efeed5fff53a1bfa3021da8d840b9fed8"
    sha256 cellar: :any,                 arm64_sonoma:  "a516eb557731cb4cda13cbcd7b23818d22b834540723b07261d13dcb77e9cb29"
    sha256 cellar: :any,                 arm64_ventura: "83dfbbe996c23ef3d11028de6ee1c64c3e56fa29627ce45e87bad237242549f7"
    sha256 cellar: :any,                 sonoma:        "570600e6a0fd2d55c9fd186cc176afa5d8bf0811156470168db0fe668bc985b5"
    sha256 cellar: :any,                 ventura:       "52748c9f86013955a0e9b4458c57d43c0aa0e8231f3be44118f775bd42a01717"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37818341c4de8a2ac6f6d715f650b3b92d273506a50f54ebf35713c7ab74a395"
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
    assert_predicate testpath"brew", :exist?
    assert_predicate testpath".brewtest", :exist?
  end
end