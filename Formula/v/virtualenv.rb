class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/8d/e9/f4550b3af1b5c71d42913430d325ca270ace65896bfd8ba04472566709cc/virtualenv-20.24.6.tar.gz"
  sha256 "02ece4f56fbf939dbbc33c0715159951d6bf14aaf5457b092e4548e1382455af"
  license "MIT"
  revision 1
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a4529508e929dd748d76e6a2e49201a4773291c0ceced429fa357559ff73e9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a7b1bdef632cf9dc558cc549237112c58a457b6cbb00538c0f3323d915a2dfb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9019c67e47a10857affbad2511619474170f2a2e159210dfbdbf3dbc035cc346"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ebb11e7fc232820c19ab4f84f322a94bfe22d169cc54d0f64af474d4eba8f07"
    sha256 cellar: :any_skip_relocation, ventura:        "9b64eff381406c5121c383a9d67575368f0d62c057e29a55f54902267a9f1b8c"
    sha256 cellar: :any_skip_relocation, monterey:       "56fea4a6b8f1428dd150fdfbc385e622e242c7d8de806d6c479ff0e1227246d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "799e0f7f9e08a2013092e42164d17c53a200ccc354dba803bb85b3ab74ce20b9"
  end

  depends_on "python@3.12"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d5/71/bb1326535231229dd69a9dd2e338f6f54b2d57bd88fc4a52285c0ab8a5f6/filelock-3.12.4.tar.gz"
    sha256 "2e6f249f1f3654291606e046b09f1fd5eac39b360664c27f5aad072012f8bcbd"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d3/e3/aa14d6b2c379fbb005993514988d956f1b9fdccd9cbe78ec0dbe5fb79bf5/platformdirs-3.11.0.tar.gz"
    sha256 "cf8ee52a3afdb965072dcc652433e0c7e3e40cf5ea1477cd4b3b1d2eb75495b3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end