class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https:github.comMusicPlayerDaemonMPD"
  license "GPL-2.0-or-later"
  revision 2
  head "https:github.comMusicPlayerDaemonMPD.git", branch: "master"

  stable do
    url "https:github.comMusicPlayerDaemonMPDarchiverefstagsv0.23.16.tar.gz"
    sha256 "a3ba8a4ef53c681ae5d415a79fbd1409d61cb3d03389a51595af24b330ecbb61"

    # support libnfs 6.0.0, upstream commit ref, https:github.comMusicPlayerDaemonMPDcommit31e583e9f8d14b9e67eab2581be8e21cd5712b47
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches557ad661621fa81b5e6ff92ab169ba40eba58786mpd0.23.16-libnfs-6.patch"
      sha256 "e0f2e6783fbb92d9850d31f245044068dc0614721788d16ecfa8aacfc5c27ff3"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "78824e8522be8ed0295a10425e51d240dd57ca42b7144575cf927a8c96a5f05d"
    sha256 cellar: :any, arm64_sonoma:  "cf82215e0eae9339430efb14492ed1d1666bc4894b3a272245276afb99d2fcfc"
    sha256 cellar: :any, arm64_ventura: "e9c07153717e45bd7ed0a520cfaf682d83de67a02ec3b34b7c99f11dc55d3474"
    sha256 cellar: :any, sonoma:        "04c50d82ff1c8ab9e8fa0b82cb20c4b22ec126de59ac9fc66440431d70ac5a23"
    sha256 cellar: :any, ventura:       "48c49888012335ccb8bc37f86d5389aa4e4e96c436da8916f953f432005a7ad0"
    sha256               x86_64_linux:  "5a78d9d87bb558211f09dced67d583c0673ed39a836ba7e583d9193cc01c35b4"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "chromaprint"
  depends_on "expat"
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "fmt"
  depends_on "game-music-emu"
  depends_on "glib"
  depends_on "icu4c@76"
  depends_on "lame"
  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "libid3tag"
  depends_on "libmikmod"
  depends_on "libmpdclient"
  depends_on "libnfs"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libshout"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libupnp"
  depends_on "libvorbis"
  depends_on macos: :mojave # requires C++17 features unavailable in High Sierra
  depends_on "mpg123"
  depends_on "opus"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "wavpack"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_linux do
    depends_on "systemd" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "jack"
    depends_on "pulseaudio"
    depends_on "systemd"
  end

  def install
    # mpd specifies -std=gnu++0x, but clang appears to try to build
    # that against libstdc++ anyway, which won't work.
    # The build is fine with G++.
    ENV.libcxx

    args = %W[
      -Dcpp_std=c++20
      --sysconfdir=#{etc}
      -Dmad=disabled
      -Dmpcdec=disabled
      -Dsoundcloud=disabled
      -Dao=enabled
      -Dbzip2=enabled
      -Dchromaprint=enabled
      -Dexpat=enabled
      -Dffmpeg=enabled
      -Dfluidsynth=enabled
      -Dnfs=enabled
      -Dshout=enabled
      -Dupnp=pupnp
      -Dvorbisenc=enabled
      -Dwavpack=enabled
      -Dgme=enabled
      -Dmikmod=enabled
      -Dsystemd_system_unit_dir=#{lib}systemdsystem
      -Dsystemd_user_unit_dir=#{lib}systemduser
    ]

    system "meson", "setup", "outputrelease", *args, *std_meson_args
    system "meson", "compile", "-C", "outputrelease", "--verbose"
    ENV.deparallelize # Directories are created in parallel, so let's not do that
    system "meson", "install", "-C", "outputrelease"

    pkgetc.install "docmpdconf.example" => "mpd.conf"
  end

  def caveats
    <<~EOS
      MPD requires a config file to start.
      Please copy it from #{etc}mpdmpd.conf into one of these paths:
        - ~.mpdmpd.conf
        - ~.mpdconf
      and tailor it to your needs.
    EOS
  end

  service do
    run [opt_bin"mpd", "--no-daemon"]
    keep_alive true
    process_type :interactive
    working_dir HOMEBREW_PREFIX
  end

  test do
    # oss_output: Error opening OSS device "devdsp": No such file or directory
    # oss_output: Error opening OSS device "devsounddsp": No such file or directory
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "[wavpack] wv", shell_output("#{bin}mpd --version")

    require "expect"

    port = free_port

    (testpath"mpd.conf").write <<~EOS
      bind_to_address "127.0.0.1"
      port "#{port}"
    EOS

    io = IO.popen("#{bin}mpd --stdout --no-daemon #{testpath}mpd.conf 2>&1", "r")
    io.expect("output: Successfully detected a osx audio device", 30)

    ohai "Connect to MPD command (localhost:#{port})"
    TCPSocket.open("localhost", port) do |sock|
      assert_match "OK MPD", sock.gets
      ohai "Ping server"
      sock.puts("ping")
      assert_match "OK", sock.gets
      sock.close
    end
  end
end