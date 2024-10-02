class Tccutil < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Utility to modify the macOS Accessibility Database (TCC.db)"
  homepage "https:github.comjacobsalmelatccutil"
  url "https:github.comjacobsalmelatccutilarchiverefstagsv1.5.0.tar.gz"
  sha256 "2f5b27f689cfb7d4799cae7ea9a22a5b016f877130b6ac91d7bf2437fa908787"
  license "GPL-2.0-or-later"
  head "https:github.comjacobsalmelatccutil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5c4eac0eba9ac4c36acdd18e6b4cd83a8e52594e00810cea23c5e5b0417f7ece"
  end

  depends_on :macos
  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  def python3
    which("python3.12")
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    rewrite_shebang python_shebang_rewrite_info(venv.root"binpython"), "tccutil.py"
    bin.install "tccutil.py" => "tccutil"
  end

  test do
    assert_match "Unrecognized command \"check\"", shell_output("#{bin}tccutil check 2>&1")
    assert_match "tccutil #{version}", shell_output("#{bin}tccutil --version")
  end
end