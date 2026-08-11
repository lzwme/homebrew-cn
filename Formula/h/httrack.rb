class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.49.20/httrack-3.49.20.tar.gz"
  sha256 "404eb28443362783817c52451cdf4d8e9b24bacd0225d053119fd1e4dfd6599e"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "ce8fe432ad418b2dd4635a90d4d4b1af6c6ba093443570dc69ee64c7b15e9b82"
    sha256 arm64_sequoia: "f5a1dcbb7e117e5dd679f82020cdc0bb09a9b77933966180f3dd8c32c2ee33ba"
    sha256 arm64_sonoma:  "b5c9f36f6183a6ad2ff2dcfe615f35655bb0734fbc29a8d4831fcd1101f0a1e9"
    sha256 sonoma:        "fc25c67d2e7657168deb26af0e4e763c57c987cdd1aa167921897069efcaa433"
    sha256 arm64_linux:   "9c1fdbcdb0bf2e1c863243f9ef451193da54b3395f2221c890aef8cd9dc495c0"
    sha256 x86_64_linux:  "2dd51e3433f44acd8ee2f501f07c87adfee4d500151659ba89a136109be0abdb"
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