class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/c1/f9/87b0637f470cd517378d0f71b58a755cc853ab5f08822e55e399ecd5bef6/dynaconf-3.3.1.tar.gz"
  sha256 "6be6b3970dfe9c3a66647ded973952a8600582a8c55e2c1842e5b21aa12ef5e1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e2feaa110dc2eec36a41e51bbdf634b67d1f544f8c49eb40ecd6812babe7cda5"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_path_exists testpath/"settings.toml"
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end