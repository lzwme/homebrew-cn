class Tccutil < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Utility to modify the macOS Accessibility Database (TCC.db)"
  homepage "https://github.com/jacobsalmela/tccutil"
  url "https://ghfast.top/https://github.com/jacobsalmela/tccutil/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "6bbf98962269497b052b7b8a6bb8bf6c119fb3b5982067007c8439d4d1154945"
  license "GPL-2.0-or-later"
  head "https://github.com/jacobsalmela/tccutil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b238ae4206117ce5abe1c17461925350cb29417619f643627d612df94e684f5d"
  end

  depends_on :macos
  depends_on "python@3.14"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), "tccutil.py"
    bin.install "tccutil.py" => "tccutil"
  end

  test do
    assert_match "Unrecognized command \"check\"", shell_output("#{bin}/tccutil check 2>&1")
    assert_match "tccutil #{version}", shell_output("#{bin}/tccutil --version")
  end
end