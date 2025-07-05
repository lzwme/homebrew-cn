class Unoserver < Formula
  include Language::Python::Virtualenv

  desc "Server for file conversions with Libre Office"
  homepage "https://github.com/unoconv/unoserver"
  url "https://files.pythonhosted.org/packages/8f/f6/75fa9085e3f871e6471a52e2541b9d33a51039c3b816e84b223a97e5566b/unoserver-3.3.1.tar.gz"
  sha256 "6bc4413d123ccd2745476288d0695d2ee632baf38e777b3e6e75a6d045b4fb17"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c713f5c8397500fcccb518697f866311af88cb22faa3fd0c25509bf2a9934a7"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "office installation", pipe_output("#{bin}/unoserver 2>&1")
  end
end