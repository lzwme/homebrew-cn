class ShairportSync < Formula
  desc "AirTunes emulator that adds multi-room capability"
  homepage "https:github.commikebradyshairport-sync"
  url "https:github.commikebradyshairport-syncarchiverefstags4.3.6.tar.gz"
  sha256 "f100ed80938ff63d305a260b0f0dd32d012ea9b64884b2802d46d862923439b8"
  license "MIT"
  head "https:github.commikebradyshairport-sync.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "8245d8d79770aa181e906101f1ef2a96fecb2c2b9c68e19625d52e6e2cda5fb3"
    sha256 arm64_sonoma:  "d43445d6cd3d5b13f391e05a066a4738f8ac6f50264c6849a978d34e2a8aa08a"
    sha256 arm64_ventura: "60d52799c5c80dea86014ff3d4ec9abf7120d6582321d26db2197db6ab11dada"
    sha256 sonoma:        "2d430533cbb4e4cdb4fabb82250377f1631927e0717e6168db956d0910a4ecb4"
    sha256 ventura:       "b46a6f87a5fd48f6ca100d3db896e5bf8c269c44fd142f8edf368b4d8bb47bbf"
    sha256 x86_64_linux:  "3717504ad42bd41555583b64254368295e6b16d9f7b496cffc7d407071f24899"
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
      --with-pa
      --with-pipe
      --with-soxr
      --with-metadata
      --with-piddir=#{var}run
      --sysconfdir=#{etc}shairport-sync
    ]
    if OS.mac?
      args << "--with-dns_sd" # Enable bonjour
      args << "--with-os=darwin"
    end
    system ".configure", *args, *std_configure_args
    system "make", "install"
  end

  def post_install
    (var"run").mkpath
  end

  service do
    run [opt_bin"shairport-sync", "--use-stderr", "--verbose"]
    keep_alive true
    log_path var"logshairport-sync.log"
    error_log_path var"logshairport-sync.log"
  end

  test do
    output = shell_output("#{bin}shairport-sync -V")
    if OS.mac?
      assert_match "libdaemon-OpenSSL-dns_sd-ao-pa-stdout-pipe-soxr-metadata", output
    else
      assert_match "OpenSSL-ao-pa-stdout-pipe-soxr-metadata-sysconfdir", output
    end
  end
end