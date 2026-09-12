class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.50.2/httrack-3.50.2.tar.gz"
  sha256 "bde231415a42adf793e5272ce436a5c22377dab94b0b2e395e3cee7c298343f0"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_golden_gate: "58dcc90893bb43a0bdcb9d82c25cec62a2514ec6f2f53f19ad1e233de53ee95d"
    sha256 arm64_tahoe:       "8fea08c20e53a046161e8238e1b589b6462c699320167c5fd51ddedb22a8649c"
    sha256 arm64_sequoia:     "87dcd04f345d0362be2d02be4a24f23f1bea6c5a947b3fbb9c0fb4e60231c887"
    sha256 arm64_linux:       "fe3ce8273c5c561d75926fde367d23cfcd61c70c6a0068f0347b35418b0e4fa1"
    sha256 x86_64_linux:      "5da51ae26f7b2ded9bf4a5e7b9b53e4e2efd498dd6047e4c619956f110fa05f5"
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