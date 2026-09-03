class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.50.1/httrack-3.50.1.tar.gz"
  sha256 "cab1ad16a975263d809e484b02bbf76c87e2212e7b5902f42d9e0c6ccf01451c"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "e73f0b952b984a61dd27a92dd6925714181e89bd3704935877f54e961164413b"
    sha256 arm64_sequoia: "8df78807a4e735a853d7a29765a48639d09bbb26c507b45848807d8a2d4e35bc"
    sha256 arm64_sonoma:  "7339ff8b3ed0128ea4d468ddc83209f59553a16f7d87de4cec6db5b9509a626c"
    sha256 arm64_linux:   "bed1b01c054f31d54c14c4ae2d8dd49061d6db7a48143b6e1532b4f892d1ce56"
    sha256 x86_64_linux:  "53467fc1326aab6cc55f9092e14308f1aa89d1f007c30904737800d5349cdeb7"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}" if OS.mac?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Don't need Gnome integration
    rm_r(Dir["#{share}/{applications,pixmaps}"])
  end

  test do
    download = "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert_path_exists testpath/"raw.githubusercontent.com"
  end
end