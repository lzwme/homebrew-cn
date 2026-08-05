class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.49.16/httrack-3.49.16.tar.gz"
  sha256 "36adb260e3f5a5a8e061b0375ac44be4d26f02b421a7dcad58033a776ec43d5d"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "1530685e9b616a2013b34a8e5d249d15d3d4fe667ad815fa12f4898505620d89"
    sha256 arm64_sequoia: "956f1de11d8995a78a771bfd759485dba1e2fc80db7bf2a930a7b27f4b8ba8d2"
    sha256 arm64_sonoma:  "b01d4ed5a3afd5d1843924a551830d8a66d3062452f4d9452cc1940375c7e32b"
    sha256 sonoma:        "eebb8b83d140ca54ce82a88db06fbdee962b89a144d71c497a00cfb01c608c7a"
    sha256 arm64_linux:   "a1b867730ed24b3644e19622504aa5b79dbbf9778a75a2bc55dc36c89a351e66"
    sha256 x86_64_linux:  "c5fed4ecaaba2c61b50f0d91918f89dfddf05a881d95ccf3e3bcdbc4b01fa386"
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