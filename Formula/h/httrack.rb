class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.50.3/httrack-3.50.3.tar.gz"
  sha256 "644d4ec0e48ad596dacd7f8017b68d8a3f1dfc140284b412b53086e7d1664e9d"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_golden_gate: "b14d8455418faf47d4c8c4f4217ad7b002b7804b51c2d99d55d37c9d4100ba96"
    sha256 arm64_tahoe:       "302aa1b3560fb56d0368eb914d0fa2d6231708b1652f3e7e14bbe5f20fb15546"
    sha256 arm64_sequoia:     "d98d00b8b3f8839baccd40676cec5e111d294e1543227ec9c092d37dcee48f10"
    sha256 arm64_linux:       "a41379e18cd93e710480f7e07236005c1636589941096702ef70c19c03a7b661"
    sha256 x86_64_linux:      "655375c9be45be507a38d9029c74a71b69b67b90d196e45410cb0a43643bdd21"
  end

  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    ENV.deparallelize
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}" if OS.mac?

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
    # Gnome integration is inert on macOS, but Linux desktops use it
    rm_r(Dir["#{share}/{applications,pixmaps}"]) if OS.mac?
  end

  test do
    download = "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert_path_exists testpath/"raw.githubusercontent.com"
  end
end