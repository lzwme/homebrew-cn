class Termaid < Formula
  include Language::Python::Virtualenv

  desc "Render Mermaid diagrams in the terminal"
  homepage "https://github.com/fasouto/termaid"
  url "https://files.pythonhosted.org/packages/3a/6f/56eab35efefdbee574ab59aa1b715781a89ae63888dbdd910c29e3435792/termaid-0.9.0.tar.gz"
  sha256 "0b183f139638015b0a8d52be214050187ea1e944c2c6f86b404c675c9e3c7ad6"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "b0c0e746bc7cf02eeba068dbeaccdabbfe7c85e66d97976e9f15c6aff1543a1b"
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