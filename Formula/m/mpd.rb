class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https:github.comMusicPlayerDaemonMPD"
  license "GPL-2.0-or-later"
  revision 6
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

    # Backport support for ICU 76+
    # Ref: https:github.comMusicPlayerDaemonMPDpull2140
    patch :DATA
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "8331fad50323d97217240e745b7023718b1514389693a69fcb1a2574e9e8c8c9"
    sha256 cellar: :any, arm64_sonoma:  "f10b98cff481aa4a5f953a490c50c9a36bee49a5343a2a5c10a15bb26994c579"
    sha256 cellar: :any, arm64_ventura: "ae555fc405b962ba4196d6acf4bb14cffd1b9103153038cea92f4cfaed34936f"
    sha256 cellar: :any, sonoma:        "6216d61f9f25b1053c62b2eeb9eec0918db32b147fc3de0478cf95191b5c2be2"
    sha256 cellar: :any, ventura:       "52fc3ccad0b75045b551ffc3e54fab067bbb915393dc7965e3261b48a00450b5"
    sha256               x86_64_linux:  "3c9bfb4c2d78a0f206733f9ae9da65ffe160987b12aac875f3a68ee79883c813"
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

__END__
diff --git asrclibicumeson.build bsrclibicumeson.build
index 92f9e6b1f..3d52213a9 100644
--- asrclibicumeson.build
+++ bsrclibicumeson.build
@@ -1,5 +1,7 @@
-icu_dep = dependency('icu-i18n', version: '>= 50', required: get_option('icu'))
-conf.set('HAVE_ICU', icu_dep.found())
+icu_i18n_dep = dependency('icu-i18n', version: '>= 50', required: get_option('icu'))
+icu_uc_dep = dependency('icu-uc', version: '>= 50', required: get_option('icu'))
+have_icu = icu_i18n_dep.found() and icu_uc_dep.found()
+conf.set('HAVE_ICU', have_icu)
 
 icu_sources = [
   'CaseFold.cxx',
@@ -13,7 +15,7 @@ if is_windows
 endif
 
 iconv_dep = []
-if icu_dep.found()
+if have_icu
   icu_sources += [
     'Util.cxx',
     'Init.cxx',
@@ -44,7 +46,8 @@ icu = static_library(
   icu_sources,
   include_directories: inc,
   dependencies: [
-    icu_dep,
+    icu_i18n_dep,
+    icu_uc_dep,
     iconv_dep,
     fmt_dep,
   ],