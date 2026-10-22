class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://ghfast.top/https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.6.1.tar.gz"
  sha256 "48d2ac1afa52d86766bc328694fa5d2d5f13a674f3e980f00d95d957453e5ee1"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_golden_gate: "d7caaf88bc84f19abbf6a6e5735075b1e1c7aa37aaeb6fb96db256663fa32041"
    sha256 arm64_tahoe:       "9881840e11514c84d2babf193da5025dfe198edaefe4f92e572cf70892c11dfc"
    sha256 arm64_sequoia:     "993a31b6d7ab7338c33137c5ff91941a497c4a1830dc03dd2f9680a6116e7647"
    sha256 arm64_linux:       "6fa8ff98f3be660d60a34cfa8e885785f9185a6cad8614205f155a8bf42072a4"
    sha256 x86_64_linux:      "c1bfd414fe7f1f2fe07c92b5032cd3105fe62a5f79347cf540512de2afb592c2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@4"
  depends_on "popt"
  depends_on "pulseaudio"

  deny_network_access!

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    args = %W[
      --with-libdaemon
      --with-ssl=openssl
      --with-ao
      --with-stdout
      --with-pulseaudio
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}/run
      --sysconfdir=#{pkgetc}
    ]
    if OS.mac?
      args << "--with-dns_sd" # Enable bonjour
      args << "--with-os=darwin"
    end
    system "./configure", *args, *std_configure_args
    system "make", "install"

    (var/"run").mkpath
  end

  service do
    run [opt_bin/"shairport-sync", "--use-stderr", "--verbose"]
    keep_alive true
    log_path var/"log/shairport-sync.log"
    error_log_path var/"log/shairport-sync.log"
  end

  test do
    output = shell_output("#{bin}/shairport-sync -V")
    if OS.mac?
      assert_match "libdaemon-OpenSSL-dns_sd-ao-PulseAudio-stdout-pipe-soxr-metadata", output
    else
      assert_match "OpenSSL-ao-PulseAudio-stdout-pipe-soxr-metadata-sysconfdir", output
    end
  end
end