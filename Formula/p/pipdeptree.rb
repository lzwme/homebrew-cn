class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/67/0d/84e80cb63ef95aac70f279a4fb98e1f29301613b709385f0bc00b5ef33e2/pipdeptree-2.31.0.tar.gz"
  sha256 "b3863e889761be597cc68cc38b3845f670ceab8d690f7b6728aa396d1e1be458"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca44327e2d6ae7712b485a442c7d86eb6bb54bf8f33150b76af82a3b7f88adf0"
  end

  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end