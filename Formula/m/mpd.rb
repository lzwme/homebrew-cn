class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https:github.comMusicPlayerDaemonMPD"
  license "GPL-2.0-or-later"
  revision 1
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
    sha256 cellar: :any, arm64_sequoia: "90e12fc71d7428a90102ffb762384846a28b39c39d7371218373c3a8a78d6406"
    sha256 cellar: :any, arm64_sonoma:  "e5f0b7dae9ca2c0230cab0476c4c4fb33254cbe20f44f083796e9ebde7792835"
    sha256 cellar: :any, arm64_ventura: "4f4b0d45c704cf13f435bc86b0b4604eface24784de5a46b7ddf249cd2b1f2de"
    sha256 cellar: :any, sonoma:        "fab14765f0a4c40f863183e13aff7fa0a33f9519e6ceaed9bff6c0f8ee17d094"
    sha256 cellar: :any, ventura:       "614c990624036f146efd9039b8912d6e6fe4a535f09de23e19aa81f406b5b343"
    sha256               x86_64_linux:  "3840d84605b21d4688f76ae5f9ca54d175a6bca9d94f4ef8b8207f479e07c77d"
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