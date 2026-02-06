class Ccextractor < Formula
  desc "Tool for extracting closed captions from video files"
  homepage "https://www.ccextractor.org"
  url "https://ghfast.top/https://github.com/CCExtractor/ccextractor/archive/refs/tags/v0.96.5.tar.gz"
  sha256 "821614d7b31d47bf3bf6217a66464b826c0f86d2bcde070b6fba74f54dff55ff"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cc8cf54859d2992ecaa3c9934a297a6b33cda1df836ba25fc3c5dd160504f8a2"
    sha256 cellar: :any,                 arm64_sequoia: "9a9862485783efbc6dcfcc00caee8508240a8a720272c04194803c3e93a2108a"
    sha256 cellar: :any,                 arm64_sonoma:  "36e4a9070c886965b67e6248232e43ec51b7b26467135cecbce927d2a6b9d690"
    sha256 cellar: :any,                 sonoma:        "00a36022a26f18b9687c73b3585021010c930be1551fb249119a991603383e6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab7e89b660f78dc777a427e0c3a23ac714989d2ed730112433984c8af14eb362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "884465dd5e1ab0dc6abd1b3155f66e5d87b15ece4af1d1896ad8eb7c8e3ce4a3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "freetype"
  depends_on "gpac"
  depends_on "libpng"
  depends_on "protobuf-c"
  depends_on "utf8proc"

  uses_from_macos "zlib"

  on_linux do
    depends_on "llvm" => :build
    depends_on "leptonica"
    depends_on "tesseract"
  end

  def install
    if OS.mac?
      cd "mac" do
        system "./build.command", "-system-libs"
        bin.install "ccextractor"
      end
    else
      cd "linux" do
        system "./build", "-system-libs"
        bin.install "ccextractor"
      end
    end
  end

  test do
    assert_match "CCExtractor", shell_output("#{bin}/ccextractor --version")
  end
end