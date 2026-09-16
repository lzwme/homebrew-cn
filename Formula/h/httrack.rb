class Httrack < Formula
  desc "Website copier/offline browser"
  homepage "https://www.httrack.com/"
  url "https://ghfast.top/https://github.com/xroche/httrack/releases/download/3.50.2/httrack-3.50.2.tar.gz"
  sha256 "bde231415a42adf793e5272ce436a5c22377dab94b0b2e395e3cee7c298343f0"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "76f2ae1c62100cd255a22e6e9f9e3afaaca66bf943bf249f7edee03101268bdd"
    sha256 arm64_tahoe:       "c71e83a97cb1e6e594edab5363cac6e0d359bee1f5c9efba4714486e10b232be"
    sha256 arm64_sequoia:     "983f2f2a6c639dfd166ec3c9ad4b6ed8e8878de78fe82df60f046e9a52d8cb95"
    sha256 arm64_linux:       "d4c265158038d0ae0eaacff167d3056bd48b79e328f8abf4c1ea766e5d5d1640"
    sha256 x86_64_linux:      "aaea8c8af82ccf22f81fbf247af4a90a125037cac5bf6b14db5bb54ba7a117a5"
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
    # Gnome integration is inert on macOS, but Linux desktops use it
    rm_r(Dir["#{share}/{applications,pixmaps}"]) if OS.mac?
  end

  test do
    download = "https://ghfast.top/https://raw.githubusercontent.com/Homebrew/homebrew/65c59dedea31/.yardopts"
    system bin/"httrack", download, "-O", testpath
    assert_path_exists testpath/"raw.githubusercontent.com"
  end
end