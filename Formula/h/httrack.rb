class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.50.4/httrack-3.50.4.tar.gz"
  sha256 "f97dbb96d110681b4349912c8bc5c4011a6c227a7d4294ea1d4f0093baea51b6"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    sha256 arm64_golden_gate: "7943d29fcd139131b21a4da5795b68c5775f55edc8c954558439ee4e5c8bfe18"
    sha256 arm64_tahoe:       "6862f0e76d3f6623ae5e7a05043049827679182f9e7e2a124c83ce00c9a5a9a2"
    sha256 arm64_sequoia:     "8d7c64e2d322d6450e7af5f41494b20a3925716d758a05f9720c7b1d0778d29e"
    sha256 arm64_linux:       "edfaab883d82cbb05d84db4978cf8c936b507b6e433c61a4172b37abfa9cb6c7"
    sha256 x86_64_linux:      "fee7cbf0232f465fc6eaa3aafb22e075c013e576f7d6709c0c1372b918274609"
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