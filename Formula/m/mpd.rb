class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https:github.comMusicPlayerDaemonMPD"
  license "GPL-2.0-or-later"
  revision 3
  head "https:github.comMusicPlayerDaemonMPD.git", branch: "master"

  stable do
    url "https:github.comMusicPlayerDaemonMPDarchiverefstagsv0.23.15.tar.gz"
    sha256 "d2865d8f8ea79aa509b1465b99a2b8f3f449fe894521c97feadc2dca85a6ecd2"

    # Compatibility with fmt 11
    patch do
      url "https:github.comMusicPlayerDaemonMPDcommit3648475f871c33daa9e598c102a16e5a1a4d4dfc.patch?full_index=1"
      sha256 "5733f66678b3842c8721c75501f6c25085808efc42881847af11696cc545848e"
    end

    # Fix missing include
    patch do
      url "https:github.comMusicPlayerDaemonMPDcommite380ae90ebb6325d1820b6f34e10bf3474710899.patch?full_index=1"
      sha256 "661492a420adc11a3d8ca0c4bf15e771f56e2dcf1fd0042eb6ee4fb3a736bd12"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "1477a629f78d3a59ec276c2ed76fcee30fab741a21c3afa05fef1f26c1f4c336"
    sha256 cellar: :any, arm64_sonoma:   "a0c5ec95e9166169ff6f6cde2f41d7c5af4aba7f96f69c09843706f811c18b02"
    sha256 cellar: :any, arm64_ventura:  "a53881cb62b2a4a5ffb73c3ada4d68ae81d7b83fdd3bddbcdb0f621289e2ca45"
    sha256 cellar: :any, arm64_monterey: "79e0919e8c4439882903acb722454e7b90ccf83b3c53c1343db1d2c37eba7484"
    sha256 cellar: :any, sonoma:         "8e89240bcd8df2bdf4b1c77365f8bde9234b23196ca5886d511e62a4a6202637"
    sha256 cellar: :any, ventura:        "eecfcd3df5af3e08b03eb11308b95a81188f886f8fd770847254351ba7c3defc"
    sha256 cellar: :any, monterey:       "89927c46ef03920991d68708b95d4449a2772797e2e88e689b15d915fbcfd169"
    sha256               x86_64_linux:   "75d0d90d316c773424592fec34f88647029259f8f71b7b3547481bfa0250c2b3"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build

  depends_on "chromaprint"
  depends_on "expat"
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "fmt"
  depends_on "glib"
  depends_on "icu4c"
  depends_on "lame"
  depends_on "libao"
  depends_on "libgcrypt"
  depends_on "libid3tag"
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

  fails_with gcc: "5"

  def install
    # mpd specifies -std=gnu++0x, but clang appears to try to build
    # that against libstdc++ anyway, which won't work.
    # The build is fine with G++.
    ENV.libcxx

    args = %W[
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