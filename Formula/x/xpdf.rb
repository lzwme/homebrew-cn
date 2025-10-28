class Xpdf < Formula
  desc "PDF viewer"
  homepage "https://www.xpdfreader.com/"
  url "https://dl.xpdfreader.com/xpdf-4.05.tar.gz"
  sha256 "92707ed5acb6584fbd73f34091fda91365654ded1f31ba72f0970022cf2a5cea"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  livecheck do
    url "https://www.xpdfreader.com/download.html"
    regex(/href=.*?xpdf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "cb4be570e78e5683aa5f8d1cd38863940ceff5c450841611b8c869cb2438a9e7"
    sha256 cellar: :any,                 arm64_sequoia: "a427e2fdfcf6d7941ee319dc9dc483104177a6460cc8d198d5905934a4b5c1c7"
    sha256 cellar: :any,                 arm64_sonoma:  "2fcac810f853552814f046a8c9121237cf1d6e2962e09977cc6e57e5b1bf26b8"
    sha256 cellar: :any,                 sonoma:        "c7c880aa82976bfd35833f8a2cb71cfab406a15f293b09b38119ec5a95f1769a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "192177145fa3698a7180404e21393799c506fdd206caf5ec3735732c9d0e94e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be1968ec32654250b756e84e6dce636b032d6c439cb05ec58903f6b48b265aea"
  end

  depends_on "cmake" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "qtbase"
  depends_on "qtsvg" => :no_linkage # for svg icons

  uses_from_macos "cups"

  conflicts_with "pdf2image", "pdftohtml", "poppler",
    because: "poppler, pdftohtml, pdf2image, and xpdf install conflicting executables"

  def install
    args = %W[-DSYSTEM_XPDFRC=#{etc}/xpdfrc]
    # Workaround for CMake 4 compatibility
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "Pages:", shell_output("#{bin}/pdfinfo #{testpath}/test.pdf")
  end
end