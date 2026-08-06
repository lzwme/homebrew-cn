class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.49.17/httrack-3.49.17.tar.gz"
  sha256 "efde3d174fe140c953927e0e2369dbcff8de5dd943d49c876068932b44b467ed"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "02ff2579f8f0371c19e17367eeadcb2926ee322045ed899e03eecf2233d4bdef"
    sha256 arm64_sequoia: "e1a936354c57d4cc5d49d21eada9bff25ecc021dc2b75a56a3de8795bbab3c66"
    sha256 arm64_sonoma:  "488297e0f6c1421c87b5c6b68e6b2e1270a5e352f7f8d31e30851efdd8bb595d"
    sha256 sonoma:        "3548ca228c4b76e4bfe417ac4d5ceca30dd61dadd349489798bdedfc0658aa2b"
    sha256 arm64_linux:   "4af157ca89595339e5dec19c4324418ae53fccfd39b4befeb1b4717c157804b1"
    sha256 x86_64_linux:  "9d0cf7c0a4f072441942b71f8e55cfe9924c65c2e14bd60ff7601e16e3ac34ed"
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