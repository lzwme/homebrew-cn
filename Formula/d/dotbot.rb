class Dotbot < Formula
  include Language::Python::Virtualenv

  desc "Tool that bootstraps your dotfiles"
  homepage "https:github.comanishathalyedotbot"
  url "https:files.pythonhosted.orgpackages0d0147fcde65e9c54f7deef31ae884b4cefaaafe4879f5ce79a39f0aba356d32dotbot-1.20.4.tar.gz"
  sha256 "1fb2610f42306d5be8aabe37c979836e00f0499e2da1d172c101239777cbab1c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "743632083e949fa17834102de3d5a8d5b9a862613e3525fc42592891513d2d87"
    sha256 cellar: :any,                 arm64_sonoma:  "7702f85fbdabebd914d0906ea4fe09382f29fdbfef4b78c6eef6ba65c6d76826"
    sha256 cellar: :any,                 arm64_ventura: "f52aa220f82f9c82a3fd0108449f833dca794ec2ef9eea01fbf01b0ef66bce57"
    sha256 cellar: :any,                 sonoma:        "09064325336e3542eb79b4de71042c696a02e081e01e8aeae8856f3c53c373c4"
    sha256 cellar: :any,                 ventura:       "b63540c64808e72a629e7919e68021e44c1db67cc1a42804428fc55118748f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc41b56e273d899cae7e7d63c91fbb613aa9b96c52b0704ef396c258d93ec1d0"
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