class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https:github.comprompt-toolkitptpython"
  url "https:files.pythonhosted.orgpackages465656cdf93d1633cba2b16486aa27978893ab3791dae51b27068e09d08bd300ptpython-3.0.26.tar.gz"
  sha256 "c8fb1406502dc349d99c57eaf06e7116f3b2deac94f02f342bae68708909f743"
  license "BSD-3-Clause"
  head "https:github.comprompt-toolkitptpython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb81ad8548341be8ff14332498535f3a34eab3e20bb07d401137f8fd958e81d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "103f3a8eb9598c75c46115d05c8bbd661918cb8ae86ac306353dacb7077d5be6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8124a8d57590310412efbb1feb709f8c4ea263f0a6d6965530509237e77bec4"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ac6947d443a2e9098eadc39481a908ed1c62865f060e505a1e8a86ccda712ea"
    sha256 cellar: :any_skip_relocation, ventura:        "f25b88be7855c8f6bed371c7a0cc909ce55fe22b9e0e966bdb5f18f5c1f3a866"
    sha256 cellar: :any_skip_relocation, monterey:       "0c77cef9d5536f7f8d7b79b805bca4531274778fe3a91a6b2739514fd4f0c6d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3d170df21e2c087835c297b7ad04d90161a840918ae2c9f8dd2a4413a2ccef2"
  end

  depends_on "pygments"
  depends_on "python@3.12"

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "jedi" do
    url "https:files.pythonhosted.orgpackagesd69999b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0ajedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "parso" do
    url "https:files.pythonhosted.orgpackagesa20e41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesccc625b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126caprompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test.py").write "print(2+2)\n"
    assert_equal "4", shell_output("#{bin}ptpython test.py").chomp
  end
end