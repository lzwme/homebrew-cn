class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://www.musicpd.org/"
  url "https://ghfast.top/https://github.com/MusicPlayerDaemon/MPD/archive/refs/tags/v0.24.13.tar.gz"
  sha256 "8c66c2bae2d9ed87a06b95724e974a5510d3347556c099b9b7b5706a7e6d3cf4"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/MusicPlayerDaemon/MPD.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "50abbad03234f71fd87cc0609d418c92f47fda6b3fc8d3da16ddd17ed3cb6d15"
    sha256 cellar: :any, arm64_sequoia: "c75f409a217278610f9550861bc351f008eee518e22ea19cfd69146d10beb038"
    sha256 cellar: :any, arm64_sonoma:  "c70e55ddcf6aa918ab8f627281cda5afc79e773a3c7b88d1bbca015dae2ae3c4"
    sha256 cellar: :any, sonoma:        "7aa0d6a3a0c5e71d8328a1f1d81f6bbb27806d97173a9ea7178bb4c678ab49a5"
    sha256               arm64_linux:   "c68b2c39979fed323c55c694fe6141490b6d05de5a6d38e367c68799a0295131"
    sha256               x86_64_linux:  "e8fd8af8a7d7535c8b924072d1994e5c20fae2cc52c1eaf212673583bbbc62c2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pkgconf" => :build

  depends_on "chromaprint"
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "fluid-synth"
  depends_on "fmt"
  depends_on "game-music-emu"
  depends_on "icu4c@78"
  depends_on "lame"
  depends_on "libao"
  depends_on "libid3tag"
  depends_on "libmikmod"
  depends_on "libmpdclient"
  depends_on "libnfs"
  depends_on "libnpupnp"
  depends_on "libogg"
  depends_on "libsamplerate"
  depends_on "libshout"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "opus"
  depends_on "pcre2"
  depends_on "sqlite"
  depends_on "wavpack"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "expat"

  on_ventura :or_older do
    depends_on "llvm"

    fails_with :clang do
      cause "Needs C++20 std::make_unique_for_overwrite"
    end
  end

  on_linux do
    depends_on "systemd" => :build
    depends_on "alsa-lib"
    depends_on "dbus"
    depends_on "jack"
    depends_on "pipewire"
    depends_on "pulseaudio"
    depends_on "systemd"
    depends_on "zlib-ng-compat"
  end

  # Work around superenv to avoid mixing `expat` usage in libraries across dependency tree.
  # Brew `expat` usage in Python has low impact as it isn't loaded unless pyexpat is used.
  # TODO: Consider adding a DSL for this or change how we handle Python's `expat` dependency
  def remove_brew_expat
    env_vars = %w[CMAKE_PREFIX_PATH HOMEBREW_INCLUDE_PATHS HOMEBREW_LIBRARY_PATHS PATH PKG_CONFIG_PATH]
    ENV.remove env_vars, /(^|:)#{Regexp.escape(formula_opt_prefix("expat"))}[^:]*/
    ENV.remove "HOMEBREW_DEPENDENCIES", "expat"
  end

  def install
    if OS.mac? && MacOS.version <= :ventura
      remove_brew_expat
      ENV.append "LDFLAGS", "-L#{formula_opt_lib("llvm")}/unwind -lunwind"
      # When using Homebrew's superenv shims, we need to use HOMEBREW_LIBRARY_PATHS
      # rather than LDFLAGS for libc++ in order to correctly link to LLVM's libc++.
      ENV.prepend_path "HOMEBREW_LIBRARY_PATHS", formula_opt_lib("llvm")/"c++"
    end

    args = %W[
      --sysconfdir=#{etc}
      -Dmad=disabled
      -Dmpcdec=disabled
      -Dao=enabled
      -Dbzip2=enabled
      -Dchromaprint=enabled
      -Dexpat=enabled
      -Dffmpeg=enabled
      -Dfluidsynth=enabled
      -Dnfs=enabled
      -Dshout=enabled
      -Dupnp=npupnp
      -Dvorbisenc=enabled
      -Dwavpack=enabled
      -Dgme=enabled
      -Dmikmod=enabled
      -Dnlohmann_json=enabled
      -Dsystemd_system_unit_dir=#{lib}/systemd/system
      -Dsystemd_user_unit_dir=#{lib}/systemd/user
    ]

    system "meson", "setup", "output/release", *args, *std_meson_args
    system "meson", "compile", "-C", "output/release", "--verbose"
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
    assert_match "[wavpack] wv", shell_output("#{bin}/mpd --version")

    require "expect"

    port = free_port

    (testpath/"mpd.conf").write <<~EOS
      bind_to_address "127.0.0.1"
      port "#{port}"
    EOS

    plugin = OS.mac? ? "osx" : "pulse"

    io = IO.popen("#{bin}/mpd --stdout --no-daemon #{testpath}/mpd.conf 2>&1", "r")
    io.expect("output: Successfully detected a #{plugin} audio device", 30)

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