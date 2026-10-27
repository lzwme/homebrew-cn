class Termaid < Formula
  include Language::Python::Virtualenv

  desc "Render Mermaid diagrams in the terminal"
  homepage "https://github.com/fasouto/termaid"
  url "https://files.pythonhosted.org/packages/3a/cb/52d485f082feb65436ed60be9e609ec21cc48353f7c998e96cf4138fd595/termaid-0.10.0.tar.gz"
  sha256 "56d543fdc0a30a11d9bb6131cf489f37e072f1229dc0948f8cb317597140b5d2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "809c104ded4b9bc0797486b3e234d82dc3c3a82fcfd2c885ad396c3ad86a0a78"
  end

  depends_on "python@3.15"

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output(bin/"termaid", "graph LR\n  A[Start] --> B[End]\n")
    assert_match "Start", output
    assert_match "End", output
    assert_match version.to_s, shell_output("#{bin}/termaid --version")
  end
end