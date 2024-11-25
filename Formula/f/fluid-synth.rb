class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https:www.fluidsynth.org"
  url "https:github.comFluidSynthfluidsyntharchiverefstagsv2.4.0.tar.gz"
  sha256 "fd4d216a3030abc56a339985ab0506328660cd77b2d71dd98c240c58c03d8f7f"
  license "LGPL-2.1-or-later"
  head "https:github.comFluidSynthfluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5872180e75e90bb83e4929c10f64639fddcc341a8e1f5516589c2b7803baba7c"
    sha256 cellar: :any,                 arm64_sonoma:  "99d675800c64673ba3f77fe7c5ae89ed149e053d18ccd38f6facde7eaffb9cbc"
    sha256 cellar: :any,                 arm64_ventura: "1b14f8eac778e1601baa6534df6aacc3db1e84c150c34c1542eedce9402afcf2"
    sha256 cellar: :any,                 sonoma:        "421f8fea695b9891048becefa4036bb1c8ddda017c4187d91071890213bb82ee"
    sha256 cellar: :any,                 ventura:       "2773618749ec8705a63a2f60d0ba35c2c4b448d5d32722a7b6704db2390c06d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae6257f67ab94ff5a3f830a55b0c0cc76623bad2c1130593df13c06e12f98aa3"
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