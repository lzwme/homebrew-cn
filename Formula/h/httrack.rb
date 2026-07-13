class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.49.12/httrack-3.49.12.tar.gz"
  sha256 "2f4362802e2b42a0f6caf5db37a53decf962e2dc876ef2c2507d1a53db270bc4"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "9cb654b11a2258521a5f8d800009679b684ebad1cef145d0596241148c48de43"
    sha256 arm64_sequoia: "ba56ca44d6a62c77e3615cbe0f750ffbfa219270d60dc273a604fcbbabf2a9de"
    sha256 arm64_sonoma:  "99f126964746a41898761ee4caafd3680df3380d6b44a154d29cc907e74708d1"
    sha256 sonoma:        "80886fe6a1772e33fa2a6d44c5bc89598f29b33775b3d5a5e4c2c2fc831b8d59"
    sha256 arm64_linux:   "6e3b4bfa9051210875017cd676b50844af849d0c2c6c5a24a899c824f15c1495"
    sha256 x86_64_linux:  "d4408502cd74d107d92ff5ff00ce2da0056ab521a825b8558d4f5f5f35eca80b"
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