class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https://github.com/mikebrady/shairport-sync"
  url "https://ghfast.top/https://github.com/mikebrady/shairport-sync/archive/refs/tags/5.2.3.tar.gz"
  sha256 "890eacbcba979a1f20ba92076310757a01adaa03161713c6d603d9bd54ba8898"
  license "MIT"
  head "https://github.com/mikebrady/shairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "1bcd8b4680797b623cc4bd9f7db211747fad999de9d1b56184fee13962d791e7"
    sha256 arm64_sequoia: "1e917d54304ec34abc9441f975a774800b47b112fa05bf0a0a1b8adc4d047623"
    sha256 arm64_sonoma:  "f18e57f973cc101bbdba0282ea5fc611758dfe2e6c5efde4fa58e7b0659f57b7"
    sha256 sonoma:        "83bcd7eb96c7b6090ae81c104631207d5f47b027d6647064d6d623478373020b"
    sha256 arm64_linux:   "74977ae1ef46a076e194204e9a3125e9b4da4264d736ceacf933a3f18bbeaf15"
    sha256 x86_64_linux:  "7ae90e3d37aec27c55fc5c04fe58b5fd102104b4b0120e2fb2944a47ace8fe43"
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