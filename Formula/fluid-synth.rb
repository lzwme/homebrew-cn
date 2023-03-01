class FluidSynth < Formula
  desc "Real-time software synthesizer based on the SoundFont 2 specs"
  homepage "https://www.fluidsynth.org"
  url "https://ghproxy.com/https://github.com/FluidSynth/fluidsynth/archive/v2.3.1.tar.gz"
  sha256 "d734e4cf488be763cf123e5976f3154f0094815093eecdf71e0e9ae148431883"
  license "LGPL-2.1-or-later"
  head "https://github.com/FluidSynth/fluidsynth.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a26af41a80f6ebc0eba1d1384711e6c6d8d33afb6b8067eb8f8823f2ac822c56"
    sha256 cellar: :any,                 arm64_monterey: "818475a9c43ce1d0455058537351af0715c60c569107ba526cd9be52544ae5ec"
    sha256 cellar: :any,                 arm64_big_sur:  "71794f63885755d5df4bc4923763ddceae628c9814c0f4c205b0fd1994a3a902"
    sha256 cellar: :any,                 ventura:        "51e6bf112fffec4af8a6c11f67693c14205a4133062c9ae67e5c1b19d10bfc8a"
    sha256 cellar: :any,                 monterey:       "780ae5444afd386bd2558cd75d52633002eacdbed8d4397d24af01d822f6d7ed"
    sha256 cellar: :any,                 big_sur:        "811ee977e81f6ce4fd6a6c9a7564e3d3045afe69b699a3be7bb6944ee36f188e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db1ecdd216ed9b722a92ae4ba6ce3274e2d3b4ad12b9688abb4b1fc56294994c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsndfile"
  depends_on "portaudio"
  depends_on "readline"

  resource "homebrew-test" do
    url "https://upload.wikimedia.org/wikipedia/commons/6/61/Drum_sample.mid"
    sha256 "a1259360c48adc81f2c5b822f221044595632bd1a76302db1f9d983c44f45a30"
  end

  def install
    args = std_cmake_args + %w[
      -Denable-framework=OFF
      -Denable-portaudio=ON
      -DLIB_SUFFIX=
      -Denable-dbus=OFF
      -Denable-sdl2=OFF
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    pkgshare.install "sf2"
  end

  test do
    # Synthesize wav file from example midi
    resource("homebrew-test").stage testpath
    wavout = testpath/"Drum_sample.wav"
    system bin/"fluidsynth", "-F", wavout, pkgshare/"sf2/VintageDreamsWaves-v2.sf2", testpath/"Drum_sample.mid"
    assert_predicate wavout, :exist?
  end
end