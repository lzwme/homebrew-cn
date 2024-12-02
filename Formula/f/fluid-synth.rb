class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https:www.fluidsynth.org"
  url "https:github.comFluidSynthfluidsyntharchiverefstagsv2.4.1.tar.gz"
  sha256 "d1e64155ac902116ed3d4dea512719d8c04ab3877db2e8fb160284379f570a2f"
  license "LGPL-2.1-or-later"
  head "https:github.comFluidSynthfluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1518e26e9cbd019eb6340f2efd4635aacdae3a1b78a6ada67b799af6f08b00ce"
    sha256 cellar: :any,                 arm64_sonoma:  "960f496c982610a5af085bc09e25f51e7a961d913f18c69f0c474c554371e82d"
    sha256 cellar: :any,                 arm64_ventura: "0d42fa358888673ecd743654f460f6f3d61ea2d20f68c7c4aa5b173363724cc2"
    sha256 cellar: :any,                 sonoma:        "d149cc8097c7e69a84348785a9f6e611b32ed662511062e1524b098600268e0a"
    sha256 cellar: :any,                 ventura:       "2fdd2e67cd284dd1b55ead088c91375a57862fb244c6dc67334de6eb5765c3da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1661626a6956e8b8b12279f14718e7c21b398a1f59b746145087e3917d62e22a"
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
    system "pkgconf", "--cflags", "--libs", "--static", lib"pkgconfigfluidsynth.pc"
  end
end