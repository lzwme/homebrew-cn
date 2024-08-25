class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/56/1a/324f1bf234cc4f98445305fd8719245318466e310e05caea7ef052748ecd/dynaconf-3.2.6.tar.gz"
  sha256 "74cc1897396380bb957730eb341cc0976ee9c38bbcb53d3307c50caed0aedfb8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "ef24e9f55aaeb333a904057639397a979f55e3c68ec33c63643b5ccbd4dc370f"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end