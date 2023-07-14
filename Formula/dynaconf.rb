class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/41/0c/dd30f938dd43e51602a5071fe1cb0707526205ca3ab17d4031842b2c7896/dynaconf-3.2.0.tar.gz"
  sha256 "a28442d12860a44fad5fa1d9db918c710cbfc971e8b7694697429fb8f1c3c620"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66867f41c42da7983a42f4cc4a1451b7da6715d47d0b3c95bcdbf8586a9e3cb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66867f41c42da7983a42f4cc4a1451b7da6715d47d0b3c95bcdbf8586a9e3cb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66867f41c42da7983a42f4cc4a1451b7da6715d47d0b3c95bcdbf8586a9e3cb4"
    sha256 cellar: :any_skip_relocation, ventura:        "8d9b54751c7d148fe6fa46c3bdc82ce615d9ac901c9311aa1575b279d1efb620"
    sha256 cellar: :any_skip_relocation, monterey:       "8d9b54751c7d148fe6fa46c3bdc82ce615d9ac901c9311aa1575b279d1efb620"
    sha256 cellar: :any_skip_relocation, big_sur:        "8d9b54751c7d148fe6fa46c3bdc82ce615d9ac901c9311aa1575b279d1efb620"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dffef2161d03af2789fafca7eb75040a1fa57932037edf2e3da691c513dd5196"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end