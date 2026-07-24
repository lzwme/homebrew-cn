class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/da/8e/79e2ab9718fa632b764ca08cf7321690819a01fad523e2b70cbd5591e99c/dynaconf-3.3.3.tar.gz"
  sha256 "1740ca23ff9da042531f507f664cb5b79b0e5120b65f98b74e1387491b6d078a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "db6cc6c0610220e057deeb601ac04aac827ded285fc8b03975a777b54227ae7a"
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