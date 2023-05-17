class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://web.archive.org/web/20230506090801/https://www.musicpd.org/"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  stable do
    url "https://ghproxy.com/https://github.com/MusicPlayerDaemon/MPD/archive/refs/tags/v0.23.12.tar.gz"
    sha256 "592192b75d33e125eacef43824901cab98a621f5f7f655da66d3072955508c69"
    # Add support for fmt 10.0.0, the hunk on NEWS does not apply
    # See https://github.com/MusicPlayerDaemon/MPD/commit/f869593ac8913e52c711e974257bd6dc0d5dbf26
    patch :DATA
  end

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_ventura:  "b61f87d7091e044b27272625be4c970ac629b846f3e63d281428fe595189b729"
    sha256 cellar: :any, arm64_monterey: "89e7643ee023bcffe730b9b066f4e2942f61cf4c60c96a4bd414fa6e1737ec81"
    sha256 cellar: :any, arm64_big_sur:  "70f960337c3d78be76c9574c0e34660986a57bae9931159e4108a732c6544bf7"
    sha256 cellar: :any, ventura:        "e7dbb9d9589197396af8f25ed2e24825245dd0faa0bd5a54befeb1e46985cc2e"
    sha256 cellar: :any, monterey:       "5a9e31c92717c5ecc4e7c05610258d64223162c0586f5726d8049fd0996a62ec"
    sha256 cellar: :any, big_sur:        "b06a6735921e7ed16917d82bd6a4d9dd0d25b977d8292beb980434ea15c468c4"
    sha256               x86_64_linux:   "b809ae499be0dff2918fe40ae887911504cd47f1c80d1b8084840df38db6b058"
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

__END__
diff --git a/src/TimePrint.cxx b/src/TimePrint.cxx
index 5bf05f6238b106250335fbe20e775443f41317b8..d47f3178bbd2c78b45b38651e179ffeedaa7d16c 100644
--- a/src/TimePrint.cxx
+++ b/src/TimePrint.cxx
@@ -20,5 +20,5 @@ time_print(Response &r, const char *name,
 		return;
 	}
 
-	r.Fmt(FMT_STRING("{}: {}\n"), name, s);
+	r.Fmt(FMT_STRING("{}: {}\n"), name, s.c_str());
 }