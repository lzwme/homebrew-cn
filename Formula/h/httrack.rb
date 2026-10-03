class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.50.5/httrack-3.50.5.tar.gz"
  sha256 "4a017e8311035ec02ee2947e14022a5f1291c86c7e67e98ee762c9486f0db39d"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_golden_gate: "d56b30795089e7d4c1f72fe58b173cd82ec2c57bb642521c530d621069ef3322"
    sha256 arm64_tahoe:       "8c0b72bdce399c8e36044ff717967974089179fd27e36004db3f297da83defe6"
    sha256 arm64_sequoia:     "3d5212a1010fc921a3cbff40f257a5d79c78b68f5617677d209765d1eaf78cd0"
    sha256 arm64_linux:       "ac4a40803b088d0ce435fa1490666def83748d283be2ed5edf70069ef12faaa8"
    sha256 x86_64_linux:      "b61dc2050d4c9487ffdbb691d8e7c16f94d5a87c2cfc5728425c5c0d7ab5dad5"
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
    rm_r(Dir["#{share}/{applications,pixmaps,icons,metainfo}"]) if OS.mac?
  end

  test do
    download = "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert_path_exists testpath/"raw.githubusercontent.com"
  end
end