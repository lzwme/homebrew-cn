class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://web.archive.org/web/20230506090801/https://www.musicpd.org/"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  stable do
    url "https://ghproxy.com/https://github.com/MusicPlayerDaemon/MPD/archive/refs/tags/v0.23.12.tar.gz"
    sha256 "592192b75d33e125eacef43824901cab98a621f5f7f655da66d3072955508c69"
    # Add support for fmt 10.0.0 on the v0.23.x branch
    # See https://github.com/MusicPlayerDaemon/MPD/commit/1690c2887f31f45bc5aee66e6283dd4bf338197c
    patch do
      url "https://github.com/MusicPlayerDaemon/MPD/commit/1690c2887f31f45bc5aee66e6283dd4bf338197c.patch?full_index=1"
      sha256 "9ca84ff99126b33ab0b4394729106209e1ef25d402225c20e67a2ed0333300c5"
    end
  end

  bottle do
    rebuild 3
    sha256 cellar: :any, arm64_ventura:  "0b65a61b40e9c365c0e7c44c7211275848b755c4f06c0a2a99eaaa2897934a37"
    sha256 cellar: :any, arm64_monterey: "ee53234d61517aca3a158b93dc986cfe5a677e129c38f03a3baecf026c9897de"
    sha256 cellar: :any, arm64_big_sur:  "c7e624950937c1c6cdca1b63a82aa231634c5e80db6c418b311e98f5cb874ea3"
    sha256 cellar: :any, ventura:        "dee7d43bc87dd206953685501eaf649c4b59caaa9541554dd04d7799a2db774d"
    sha256 cellar: :any, monterey:       "5dd87a5f71e12cae5fa1a11e87d18c0c5a3e3152ff1c2f3ae21d79381e803ea4"
    sha256 cellar: :any, big_sur:        "d22eab239b07a913307533961a016450ef31639037b2680dbc207457dbf34a70"
    sha256               x86_64_linux:   "c725f99c5ea6af7b1210ae4800c232fb2e36cf4a538173041ac86fc874d3c1c3"
  end

  depends_on "boost" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
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
  depends_on "libsamplerate"
  depends_on "libshout"
  depends_on "libupnp"
  depends_on "libvorbis"
  depends_on macos: :mojave # requires C++17 features unavailable in High Sierra
  depends_on "opus"
  depends_on "sqlite"

  uses_from_macos "curl"

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
      -Dexpat=enabled
      -Dffmpeg=enabled
      -Dfluidsynth=enabled
      -Dnfs=enabled
      -Dshout=enabled
      -Dupnp=pupnp
      -Dvorbisenc=enabled
    ]

    system "meson", "setup", "output/release", *args, *std_meson_args
    system "meson", "compile", "-C", "output/release"
    ENV.deparallelize # Directories are created in parallel, so let's not do that
    system "meson", "install", "-C", "output/release"

    pkgetc.install "doc/mpdconf.example" => "mpd.conf"
  end

  def caveats
    <<~EOS
      MPD requires a config file to start.
      Please copy it from #{etc}/mpd/mpd.conf into one of these paths:
        - ~/.mpd/mpd.conf
        - ~/.mpdconf
      and tailor it to your needs.
    EOS
  end

  service do
    run [opt_bin/"mpd", "--no-daemon"]
    keep_alive true
    process_type :interactive
    working_dir HOMEBREW_PREFIX
  end

  test do
    # oss_output: Error opening OSS device "/dev/dsp": No such file or directory
    # oss_output: Error opening OSS device "/dev/sound/dsp": No such file or directory
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    require "expect"

    port = free_port

    (testpath/"mpd.conf").write <<~EOS
      bind_to_address "127.0.0.1"
      port "#{port}"
    EOS

    io = IO.popen("#{bin}/mpd --stdout --no-daemon #{testpath}/mpd.conf 2>&1", "r")
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