class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/a3/65/72c1346001fc92f3b2f69d126918f5f7ef96c9ad439256b05a614ca7df1c/translate_toolkit-3.19.19.tar.gz"
  sha256 "f8099801886845f46f63457ceb312284421b76711e76e9053b9c1ae50b2faf16"
  license "GPL-3.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0500d76142f4bc2d68c2ecf253f6bfff231d6a9274cdabb180c56e848599555d"
    sha256 cellar: :any, arm64_sequoia: "e2950503788e6ea3495ae0459e40b03160e5b34e6210994b593158407c4b74e2"
    sha256 cellar: :any, arm64_sonoma:  "e5735cd82a465bc5b0c8b73824f4636413fd7bfccec4b3344cea13c6c14cb573"
    sha256 cellar: :any, arm64_linux:   "1a7034f965033650e01af5a67746f09bd1a8a4a1274aee378b8558b442e224be"
    sha256 cellar: :any, x86_64_linux:  "e5dfb4348d89063280572877d48bf73d9231f92ca3b5741a8107c268c3e1c96a"
  end

  depends_on "rust" => :build # for `unicode_segmentation_py`
  depends_on "python@3.14"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ad/a9/970b8fa0ecc4fbf1dfaed0d89bbc1fc1421b25ec26a2038c91e872dc6c8e/lxml-6.1.2.tar.gz"
    sha256 "1055241852f2b02068af4a625a5d32c087db193c12251928af2562ecd2239f18"
  end

  resource "unicode-segmentation-rs" do
    url "https://files.pythonhosted.org/packages/0b/02/e5804acc54945ecf29a280f5f173db61c019166bfe3adeee386f4c135f17/unicode_segmentation_rs-0.3.3.tar.gz"
    sha256 "d6625b2d3435ca814c9dd6590d39ae58ebeb8a4891eecb81446ad8b3e917f39b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end