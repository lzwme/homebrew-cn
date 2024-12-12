class Repren < Formula
  include Language::Python::Virtualenv

  desc "Rename anything using powerful regex search and replace"
  homepage "https:github.comjlevyrepren"
  url "https:files.pythonhosted.orgpackages832c2086d6b7bc88fb115aa2dd00641a1ade8a22e4854e7f4d290133bfc6a6d1repren-1.0.1.tar.gz"
  sha256 "6e5eeaa211154abed194eaa09a7ae8a5c760c0dfb103636542221089f4d335e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e67e2a780fcea707e9f2c3e40dbe897c6ffb64580c065015701e1c891518ea8"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}repren --version")

    (testpath"test.txt").write <<~EOS
      Hello World!
      Replace Me
    EOS

    system bin"repren", "--from", "Replace", "--to", "Modify", testpath"test.txt"
    assert_match "Modify Me", (testpath"test.txt").read
  end
end