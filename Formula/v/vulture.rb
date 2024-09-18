class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https:github.comjendrikseippvulture"
  url "https:files.pythonhosted.orgpackages078f5e24a3587d7b034544ec6fc5db2cb5e9f9c2ff86e800d73ab10f5ca806c0vulture-2.12.tar.gz"
  sha256 "c35e98e992eb84b01cdadbfeb0aca2d44363e7dfe6c19416f65001ae69360ccc"
  license "MIT"
  head "https:github.comjendrikseippvulture.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2ed9aae753cf4b217ba15522fb2adde6ec43ddcb1cdec0ecc055ddaa53a53bfe"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "vulture #{version}\n", shell_output("#{bin}vulture --version")

    (testpath"unused.py").write "class Unused: pass"
    assert_match "unused.py:1: unused class 'Unused'", shell_output("#{bin}vulture #{testpath}unused.py", 3)
    (testpath"used.py").write "print(1+1)"
    assert_empty shell_output("#{bin}vulture #{testpath}used.py")
  end
end