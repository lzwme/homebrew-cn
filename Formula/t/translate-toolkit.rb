class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https:toolkit.translatehouse.org"
  url "https:files.pythonhosted.orgpackages1822d5af1716b40e5c27755612ad6edc0589cfe01b5e9f887bb707e3ccbdeb2ctranslate_toolkit-3.14.8.tar.gz"
  sha256 "b450d7173fb8fdde094f59cc9ef0b698c9ef8825659930dd9392a92c97c7a82a"
  license "GPL-2.0-or-later"
  head "https:github.comtranslatetranslate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b92f4d778d1cdb2ca4b6b5608b1c97e15c7a6a2e569331d68257b3bc14c2ed52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fdbcd50f22efc31c26d87c503f00991a9a381ae8b0c88675dd050e3035899d2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dac65da7faffc88cdf909712ff25e0fa945a084c4f9bbd8429a6dfdab94130df"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c078a2a216a80067a15fdfc92cd42742b9bc16c8f926f973af8e75de74256aa"
    sha256 cellar: :any_skip_relocation, ventura:       "cdf68364b922ef8b0b667f36d62d4aa82e515bddd8f134c938ea2f90a6ae746f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ade7e42a5d85ab331b761d960db55ae53fd91b7d0056fed79d60db48b12f5d07"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "cwcwidth" do
    url "https:files.pythonhosted.orgpackages237603fc9fb3441a13e9208bb6103ebb7200eba7647d040008b8303a1c03e152cwcwidth-0.1.10.tar.gz"
    sha256 "7468760f72c1f4107be1b2b2854bc000401ea36a69daed36fb966a1e19a7a124"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackageseff6c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}podebug --version")
  end
end