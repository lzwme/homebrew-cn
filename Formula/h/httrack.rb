class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.49.19/httrack-3.49.19.tar.gz"
  sha256 "ada3c241f2b39bf55c4f01657bcd6cd96e5c0452838223a9bf67445a3a844cf4"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_tahoe:   "e2ba5b428c8d957c509955dce8781fb074e0e4bdfd60b901f85fa8055700fef1"
    sha256 arm64_sequoia: "32f4884c92b1f6fabffb87577cd968559b2939e21b9333b9153b74ddba7067c5"
    sha256 arm64_sonoma:  "969d11c96b5b9dde8ee97ed72cf5555788a9ef6b39f5b1358dfb7f80ce553e8b"
    sha256 sonoma:        "174fd936e021c44d73f75a1a4c16faeb2f2892e81f5e6f7e2f5cdff9648bf878"
    sha256 arm64_linux:   "c1f2f1076d02429f58112d60c04d0360b5730e482746dda9e34e55f81d7bdee1"
    sha256 x86_64_linux:  "f018071a22b2e1d000d6a436e854adf15ed121bed773704f61ed7e90afdcf304"
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