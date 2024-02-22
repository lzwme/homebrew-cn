class Gcovr < Formula
  include Language::Python::Virtualenv

  desc "Reports from gcov test coverage program"
  homepage "https:gcovr.com"
  url "https:files.pythonhosted.orgpackagesa5d9fc88c9df718e44dad943fec14db80e49cc0b1a592bbbf691f56a3955ccafgcovr-7.0.tar.gz"
  sha256 "d4124f89e9299cce4a0b2fda9b9cd6c07c4b7d0e94705eb071fd332671ee1125"
  license "BSD-3-Clause"
  head "https:github.comgcovrgcovr.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5566f0c6f14364945c835df2947db9e695335b84ab73355a62385119f3ab197"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5a93a75d623714d4c2c50d92b81ce127594a902284f1f1c00dd664112683e80"
    sha256 cellar: :any,                 arm64_monterey: "09ed520fa85988b5b384762d5c8390beffdce2748a888a56922888914da08689"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bf4a88b739a1e9e339a024eec252e387a54e723e4b7104708d37a2e9f51a12b"
    sha256 cellar: :any_skip_relocation, ventura:        "dca05368949b6c730cc9bef2c1e06cc1d80f606837e02fb398b6ab9876b30d1d"
    sha256 cellar: :any,                 monterey:       "e450dacb2d35ca4243b61dc099371d70cb8a9c91117144a1bd2167b74a3b08f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204b86011ea81e0925fd6a80fa6c6c83e89dc43d8553090c690338c5ea6e8b01"
  end

  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesb25e3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages2bb4bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"example.c").write "int main() { return 0; }"
    system ENV.cc, "-fprofile-arcs", "-ftest-coverage", "-fPIC", "-O0", "-o",
                   "example", "example.c"
    assert_match "Code Coverage Report", shell_output("#{bin}gcovr -r .")
  end
end