class Vulture < Formula
  include Language::Python::Virtualenv

  desc "Find dead Python code"
  homepage "https:github.comjendrikseippvulture"
  url "https:files.pythonhosted.orgpackages1d7de78586863119fe28741c347988f892301319ce05edd11dbe0b45b18cc3b9vulture-2.13.tar.gz"
  sha256 "78248bf58f5eaffcc2ade306141ead73f437339950f80045dce7f8b078e5a1aa"
  license "MIT"
  head "https:github.comjendrikseippvulture.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5408ae2a690fedee282cfd61c0ce9ba10c2b863600b3ff75fd0ebeca7572b500"
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