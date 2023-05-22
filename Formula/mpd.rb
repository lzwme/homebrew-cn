class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://web.archive.org/web/20230506090801/https://www.musicpd.org/"
  license "GPL-2.0-or-later"
  revision 2
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
    sha256 cellar: :any, arm64_ventura:  "ef62ce5662b9a6e866ab9f260ffd603c76f73e9167e390cf97c0b5452fab37bd"
    sha256 cellar: :any, arm64_monterey: "5cc9fd72c0b803007c49cce8e897eac1fc3f222d44968f1c8450016f95688356"
    sha256 cellar: :any, arm64_big_sur:  "80f9052e05dbb8ef769eecb5cf2e71861f4f989a8da327de0ec5d942cf224e07"
    sha256 cellar: :any, ventura:        "6e6348ea74f1caa85b7d86e4d1f50d4e6ecacac9dd9c685a533629a96124f64c"
    sha256 cellar: :any, monterey:       "739fc0d4bd2609667bb9037a916968b73fb79501e2b4755a005a1e53a4fe0c4a"
    sha256 cellar: :any, big_sur:        "26f2760790ac7f2fd166f1af151eff94182850db28557a24dde4b685894aebf8"
    sha256               x86_64_linux:   "f55ed473d38ec0f1a575adfb395de1096bb42da008c4aad2a7d1b992cdd1ec58"
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