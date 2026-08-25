class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://ghfast.top/https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.2.2.2.tar.gz"
  sha256 "d095bbfaf3bf245ffcdd15c5a065804b037c17ed83a229575cc46cc1d6b3b121"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "44bbd47be88607ced8b5ee12c567ff60938aa8ff086f565a0ac9949ee9f27075"
    sha256 arm64_sequoia: "fa847c537a71e786123e70fd2218ef3657e4924e24bd079e955b791ac85bfedd"
    sha256 arm64_sonoma:  "d4c37770adf09271c6a5c740a4f7bc0b299f4eae67992ca72fd8c69ba63a0222"
    sha256 sonoma:        "a3eb2f6f75f27b08368e139bf422b9975dd721846a9094d5174757410b1702c8"
    sha256 arm64_linux:   "ac7c126cd8fa300c5889f351dd53627ee39337bad7f2a29dc9dfbb95b28724f3"
    sha256 x86_64_linux:  "5cecc1c973a5eaf5183a8c378923d61a5bf1928e8294249d608c23aeecc75c45"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libao"
  depends_on "libconfig"
  depends_on "libdaemon"
  depends_on "libsoxr"
  depends_on "openssl@3"
  depends_on "popt"
  depends_on "pulseaudio"

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