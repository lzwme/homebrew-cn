class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.50.0/httrack-3.50.0.tar.gz"
  sha256 "8d86694cc84cf25c00fc544c090c3c0605102be9b30020f28533ab3c4f7008fe"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "05927252ee2360225f44ff52f66c41fbed5a83090c66dabcfe80ce29878a0c53"
    sha256 arm64_sequoia: "cbf5772ffed694b93f047bd28431cfb5dde33bf2e6d4b81cff2ca880e5f22fd1"
    sha256 arm64_sonoma:  "a2ca1734c1ea0bc4e3b6ae3666177e99913bb55982c7fd375fe5816fb1a06e51"
    sha256 arm64_linux:   "ed1630409efc122b55fc6938b838815359ada12608b8fc31e0f5d4cd1712dd06"
    sha256 x86_64_linux:  "63f0365ab8627d61abfaf18509c8328d4cd8c9b95821e36157ec391620615638"
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