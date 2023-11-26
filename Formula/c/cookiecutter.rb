class Cookiecutter < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates"
  homepage "https://github.com/cookiecutter/cookiecutter"
  url "https://files.pythonhosted.org/packages/1a/5d/9f6a7b748436597060654c8b5815dabedd78893e566bc9838c6dcbf05e04/cookiecutter-2.5.0.tar.gz"
  sha256 "e61e9034748e3f41b8bd2c11f00d030784b48711c4d5c42363c50989a65331ec"
  license "BSD-3-Clause"
  head "https://github.com/cookiecutter/cookiecutter.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "63ef47cde166c85edcbdb3fa28abf13aa8529d64340d6340c6e99d213b7ca001"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec0f93255eca1e3353d861be72a9e41a44de59f6f9a0d107a01074edff5d95e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fca4b10868384750526006cb473b561a81d9a97ba1335a01be2c5dda4c42eee3"
    sha256 cellar: :any_skip_relocation, sonoma:         "882b12c81215cccfd62cfd978aeff99ded4a5f2c7ba0b63a278db12d5c11e826"
    sha256 cellar: :any_skip_relocation, ventura:        "0a6142c430b97d88a9968f2643b7a7fcf5232f08ab78728e342ab9c8f77569c2"
    sha256 cellar: :any_skip_relocation, monterey:       "f51a74efb8bc31c0b18114f8cbd72388538304af2bde70b4235ebf015c140ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32e9f2a4aa67f70601cc4c0b01d5fc13ce81f24a628be6b6f4502a0881b0a78d"
  end

  depends_on "pygments"
  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python-jinja"
  depends_on "python-markupsafe"
  depends_on "python-requests"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "binaryornot" do
    url "https://files.pythonhosted.org/packages/a7/fe/7ebfec74d49f97fc55cd38240c7a7d08134002b1e14be8c3897c0dd5e49b/binaryornot-0.4.4.tar.gz"
    sha256 "359501dfc9d40632edc9fac890e19542db1a287bbcfa58175b66658392018061"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/de/63/0f60208d0d3dde1a87d30a82906fa9b00e902b57f1ae9565d780de4b41d1/python-slugify-8.0.1.tar.gz"
    sha256 "ce0d46ddb668b3be82f4ed5e503dbc33dd815d83e2eb6824211310d3fb172a27"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/a7/ec/4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9d/rich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/1b/2d/f189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6f/types-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"cookiecutter", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    system "git", "clone", "https://github.com/audreyr/cookiecutter-pypackage.git"
    system bin/"cookiecutter", "--no-input", "cookiecutter-pypackage"
    assert (testpath/"python_boilerplate").directory?
  end
end