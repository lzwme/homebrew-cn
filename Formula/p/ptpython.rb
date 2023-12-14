class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/3f/dc/118d1dfd22e5274f3cc341cb3c92b128dba6c47d2c8749d213bf6b7d1e16/ptpython-3.0.24.tar.gz"
  sha256 "6bc48211c0f6b5fc1ccfe617485167070311d7c79014eb9c06984e90802b54b0"
  license "BSD-3-Clause"
  head "https://github.com/prompt-toolkit/ptpython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4060c74dfa08fe09093aa717fc7cb7fa122339208b49caf043c518279e4c9cd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d684d442be1add09c9f4ee0521b8b42de192d3b7ed2281caa74b5372616121d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b8a8aa28f1ee4d5ca4af284b2fa01a778afd22d31f3aeaca1026d84c45cc5a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "65ff46af0a3b90d56156cc0063e05e6c4469dce1069181ece51d5fdc5def03cb"
    sha256 cellar: :any_skip_relocation, ventura:        "3d9aa1229ed5b34be3d2db377f62367305a8dfd7442a8323d6860415c3c6fdc3"
    sha256 cellar: :any_skip_relocation, monterey:       "097e167f29fdf1371a912500871eb2312f953c0b47f1f09c67b1dc434cb4220d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e114d13f3557e48aae6eb666f12d89525f7e552dadfd1563bea58ab06b3046ef"
  end

  depends_on "pygments"
  depends_on "python@3.12"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/d6/99/99b493cec4bf43176b678de30f81ed003fd6a647a301b9c927280c600f0a/jedi-0.19.1.tar.gz"
    sha256 "cf0496f3651bc65d7174ac1b7d043eff454892c708a87d1b683e57b569927ffd"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4", shell_output("#{bin}/ptpython test.py").chomp
  end
end