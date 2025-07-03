class Unoserver < Formula
  include Language::Python::Virtualenv

  desc "Server for file conversions with Libre Office"
  homepage "https:github.comunoconvunoserver"
  url "https:files.pythonhosted.orgpackages83374f476270dba1a542fcd7a5b956ab42b84afb7d28913fc793162ea3b0daceunoserver-3.3.tar.gz"
  sha256 "6167030773c6b1e4699771f97a38959ea5f974854b4d541021836bf6fcbaa783"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c865486a38f9105edd8afce025a076ef85e8c99a1926ac77503928812ef8f5a"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "office installation", pipe_output("#{bin}unoserver 2>&1")
  end
end