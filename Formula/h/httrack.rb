class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.49.22/httrack-3.49.22.tar.gz"
  sha256 "9df3dfc1d4ba827a9a5ff9b02d83265566d15a151cd65b806c038a68d5101621"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "d0a0a2b1d455d370b79e3518d6748c13994e5edd4c67fb838e349fc09edfb5fa"
    sha256 arm64_sequoia: "ced7adaaaff6d633db76c8d220aa438ea4916d89a7532eeb48bf1aea266da1d0"
    sha256 arm64_sonoma:  "34eaba9306c360145650fac65082f6df1cd193d02e3bcc4a646225a21f4509cb"
    sha256 sonoma:        "96f8743c47e648a476ef16d8a23eff76e027873b244c4f2190a972b20c8d13f9"
    sha256 arm64_linux:   "3a87b432ee51f9a1331286831e1f040381c875b4277018029a32b92e1b8217d3"
    sha256 x86_64_linux:  "8433370c2716efb9708304e51040d20d84217b21b6243c7174d02401c35336c1"
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