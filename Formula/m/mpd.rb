class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https:www.musicpd.org"
  license "GPL-2.0-or-later"
  revision 2
  head "https:github.comMusicPlayerDaemonMPD.git", branch: "master"

  stable do
    url "https:github.comMusicPlayerDaemonMPDarchiverefstagsv0.23.17.tar.gz"
    sha256 "6fcdc5db284297150734afd9b3d1a5697a29f6297eff1b56379018e31d023838"

    # support libnfs 6.0.0, upstream commit ref, https:github.comMusicPlayerDaemonMPDcommit31e583e9f8d14b9e67eab2581be8e21cd5712b47
    patch do
      url "https:raw.githubusercontent.comHomebrewformula-patches557ad661621fa81b5e6ff92ab169ba40eba58786mpd0.23.16-libnfs-6.patch"
      sha256 "e0f2e6783fbb92d9850d31f245044068dc0614721788d16ecfa8aacfc5c27ff3"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "e75d7e545378317554e51e1c4f7d94cfa75380b00dde5b50a955963b1095857d"
    sha256 cellar: :any, arm64_sonoma:  "a2d726e27a04e06885974622a1b406a7a74050a447a60bd2ede454ed3dc767a1"
    sha256 cellar: :any, arm64_ventura: "80873f92f2c8acf97908b734fb6cd765db587f9777b47058e309e28f7b8b306b"
    sha256 cellar: :any, sonoma:        "b03a179d88bfba90b4b2e9cffe7fd4b0618008f6bcea1c0e530f3337304ec1e7"
    sha256 cellar: :any, ventura:       "74f7e4be6592d64afdd9f8140cf98563f1bd2fcd9ddaef48e3f6036d5ecfefc6"
    sha256               x86_64_linux:  "83eb62450b51cd37ede830ae2cf52cc55b9acc9ef94b9b4349bfdf58fd957aa7"
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
  depends_on "icu4c@77"
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

    # https:github.comMusicPlayerDaemonMPDpull2198
    inreplace "srclibnfsmeson.build", "['>= 4', '< 6']", "['>= 4']"

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