class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.49.24/httrack-3.49.24.tar.gz"
  sha256 "126c047a74f9c9944bfc6339ff310131caa319b67e26e29af81cc62dac287531"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "f375236677e8330abcf58957ac54e705bea68f2030e15fd4676ed161781d206b"
    sha256 arm64_sequoia: "e7b45eb41412f85195c841713c21472b2a358cbdc362917cad6f1cec44d3ad9b"
    sha256 arm64_sonoma:  "263ffbeaa87ce461b985846da5dcb05b03f31ac7dc032bf1ca35298f0ce3d80b"
    sha256 sonoma:        "62132b08e9c4fc6069efe0f09669c03915933608f62a4c52f7b5c1d040414b4e"
    sha256 arm64_linux:   "c041771733d92e24082c0753a243f8a02e3fe790c961d1bc0d5f7c1c96386148"
    sha256 x86_64_linux:  "40fd8537e8f486e86db1726428bf1b7164b171e53ee1981db19ce6038a506ee6"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize
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