class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://ghfast.top/https://github.com/vslavik/diff-pdf/releases/download/v0.5.3/diff-pdf-0.5.3.tar.gz"
  sha256 "dc4004fe1199eebf381b5e0f2a60b6b59ff73434730e4f0aae1e0d02fa171b98"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "f20d201e44ab8e8932c9faa046ef2a923c631391f8b0d0bc8d5e917596b1eb46"
    sha256 cellar: :any, arm64_tahoe:       "7f271d046458808b4fc0a4436c307e2c68dd2deedddbcab5544517ac7b6955f4"
    sha256 cellar: :any, arm64_sequoia:     "f15e05f1baccb88a389aa670b72c20d76e1fa96ec1aa60698324c42148e6cee3"
    sha256 cellar: :any, arm64_linux:       "6037d1b7b7db433d170222b1e5e71d47c6156525b8b4ffcaae28778832f46d44"
    sha256 cellar: :any, x86_64_linux:      "d7d668cb169a4e392410107f865bc78c42d703cdd5cc10fe808eab2cda70c03a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "glib"
  depends_on "poppler"
  depends_on "wxwidgets"

  on_macos do
    depends_on "gettext"
  end

  def install
    wxwidgets = deps.find { |dep| dep.name.match?(/^wxwidgets(@\d+(\.\d+)*)?$/) }.to_formula
    wx_config = wxwidgets.opt_bin/"wx-config-#{wxwidgets.version.major_minor}"
    system "./configure", "--disable-silent-rules", "--with-wx-config=#{wx_config}", *std_configure_args
    system "make", "install"
  end

  test do
    testpdf = test_fixtures("test.pdf")
    system bin/"diff-pdf", "--output-diff=no_diff.pdf", testpdf, testpdf
    assert_path_exists testpath/"no_diff.pdf"
  end
end