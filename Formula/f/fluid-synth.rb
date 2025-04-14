class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https:www.fluidsynth.org"
  url "https:github.comFluidSynthfluidsyntharchiverefstagsv2.4.5.tar.gz"
  sha256 "2d2a5ca35bbb3f3fd241ef388a0cb3ae5755ebbb78121c7869f02b021d694810"
  license "LGPL-2.1-or-later"
  head "https:github.comFluidSynthfluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "723778a372186f82a5aef3e8e4850ad277f93d933a660ce3d86eeb1fba993a08"
    sha256 cellar: :any,                 arm64_sonoma:  "a7a9a4ec2dc74185dbc46e0f28884502138010fe594bdd5ca3a1ffe1dc9859f8"
    sha256 cellar: :any,                 arm64_ventura: "715ce291343f5c2c220181aa6ca420c36682f8119087d404fad52890fc589757"
    sha256 cellar: :any,                 sonoma:        "b03047b86106a091b8ced9791b6f132ee92cb36261a994f8847b0e46f967f7be"
    sha256 cellar: :any,                 ventura:       "0f51cca82bb831241b6d45254831d28c09deb2cb68ea2a3c0579e63a23b663f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5572aad8900f18e60d3fabf084e90d9ef703508eb40973fe7c387aa1fe0f75ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d419f58b4e4c27fffc85862dae78a71e05d9af73f9176583f0e3e34a550230a"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "glib"
  depends_on "libsndfile"
  depends_on "portaudio"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "jack"
    depends_on "systemd"
  end

  resource "homebrew-test" do
    url "https:upload.wikimedia.orgwikipediacommons661Drum_sample.mid"
    sha256 "a1259360c48adc81f2c5b822f221044595632bd1a76302db1f9d983c44f45a30"
  end

  def install
    args = %W[
      -Denable-alsa=#{OS.linux?}
      -Denable-aufile=ON
      -Denable-coverage=OFF
      -Denable-coreaudio=#{OS.mac?}
      -Denable-coremidi=#{OS.mac?}
      -Denable-dart=OFF
      -Denable-dbus=OFF
      -Denable-dsound=OFF
      -Denable-floats=OFF
      -Denable-fpe-check=OFF
      -Denable-framework=OFF
      -Denable-ipv6=ON
      -Denable-jack=#{OS.linux?}
      -Denable-ladspa=OFF
      -Denable-lash=OFF
      -Denable-libinstpatch=OFF
      -Denable-libsndfile=ON
      -Denable-midishare=OFF
      -Denable-network=ON
      -Denable-opensles=OFF
      -Denable-oboe=OFF
      -Denable-openmp=OFF
      -Denable-oss=OFF
      -Denable-pipewire=OFF
      -Denable-portaudio=ON
      -Denable-profiling=OFF
      -Denable-pulseaudio=OFF
      -Denable-readline=ON
      -Denable-sdl2=OFF
      -Denable-systemd=#{OS.linux?}
      -Denable-trap-on-fpe=OFF
      -Denable-threads=ON
      -Denable-ubsan=OFF
      -Denable-wasapi=OFF
      -Denable-waveout=OFF
      -Denable-winmidi=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args

    # On macOS, readline is keg-only so use the absolute path to its pc file
    # uses_from_macos "readline" produces another error
    # Related error: Package 'readline', required by 'fluidsynth', not found
    if OS.mac?
      inreplace "buildfluidsynth.pc",
                "readline",
                "#{Formula["readline"].opt_lib}pkgconfigreadline.pc"
    end

    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "sf2"

    system "cmake", "-S", ".", "-B", "static", *args, *std_cmake_args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "static"
    lib.install "staticsrclibfluidsynth.a"
  end

  test do
    # Synthesize wav file from example midi
    resource("homebrew-test").stage testpath
    wavout = testpath"Drum_sample.wav"
    system bin"fluidsynth", "-F", wavout, pkgshare"sf2VintageDreamsWaves-v2.sf2", testpath"Drum_sample.mid"
    assert_path_exists wavout

    # Check the pkg-config module
    ENV.append_path "PKG_CONFIG_PATH", Formula["systemd"].lib"pkgconfig" if OS.linux?
    system "pkgconf", "--cflags", "--libs", "--static", lib"pkgconfigfluidsynth.pc"
  end
end