class PythonBuild < Formula
  include Language::Python::Virtualenv

  desc "Simple, correct PEP 517 build frontend"
  homepage "https:github.compypabuild"
  url "https:files.pythonhosted.orgpackagesddbb4a1b7e3a7520e310cf7bfece43788071604e1ccf693a7f0c4638c59068d6build-1.2.2.tar.gz"
  sha256 "119b2fb462adef986483438377a13b2f42064a2a3a4161f24a0cca698a07ac8c"
  license "MIT"
  head "https:github.compypabuild.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d4a9e1c5df3fb300ca785a9aa478e78ee86c0c91d0acedbaba29e67a10bfcc31"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "058b5a61e8df225c99753f870b5f23801dccd34d79bc2193f7e8c2b0f8cc3895"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "058b5a61e8df225c99753f870b5f23801dccd34d79bc2193f7e8c2b0f8cc3895"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "058b5a61e8df225c99753f870b5f23801dccd34d79bc2193f7e8c2b0f8cc3895"
    sha256 cellar: :any_skip_relocation, sonoma:         "d4ea94bfdc112f2ae7026b4eef2353969fca988ea4d80f57a76ef28b0796cf1c"
    sha256 cellar: :any_skip_relocation, ventura:        "d4ea94bfdc112f2ae7026b4eef2353969fca988ea4d80f57a76ef28b0796cf1c"
    sha256 cellar: :any_skip_relocation, monterey:       "d4ea94bfdc112f2ae7026b4eef2353969fca988ea4d80f57a76ef28b0796cf1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "058b5a61e8df225c99753f870b5f23801dccd34d79bc2193f7e8c2b0f8cc3895"
  end

  depends_on "python@3.12"

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pyproject-hooks" do
    url "https:files.pythonhosted.orgpackagesc7076f63dda440d4abb191b91dc383b472dae3dd9f37e4c1e4a5c3db150531c6pyproject_hooks-1.1.0.tar.gz"
    sha256 "4b37730834edbd6bd37f26ece6b44802fb1c1ee2ece0e54ddff8bfc06db86965"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    stable.stage do
      system bin"pyproject-build"
      assert_predicate Pathname.pwd"distbuild-#{stable.version}.tar.gz", :exist?
      assert_predicate Pathname.pwd"distbuild-#{stable.version}-py3-none-any.whl", :exist?
    end
  end
end