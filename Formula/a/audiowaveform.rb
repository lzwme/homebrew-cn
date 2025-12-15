class Audiowaveform < Formula
  desc "Generate waveform data and render waveform images from audio files"
  homepage "https://codeberg.org/chrisn/audiowaveform"
  url "https://codeberg.org/chrisn/audiowaveform/archive/1.10.3.tar.gz"
  sha256 "f33680a4c74a718648ee0567511537ad80e015fb3bf5c8440a8176414afb415a"
  license "GPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2d47b4665522e77242a8b50ef9238082d917b7135b60f80814c90bc24be1d0b5"
    sha256 cellar: :any,                 arm64_sequoia: "56eb4e9b6ac8aa315123a2f8cf7ada427229bacfbf098044975ca7170b5720b5"
    sha256 cellar: :any,                 arm64_sonoma:  "20f1a999349a1a54b17c435e965ef19a119f32c5d86b29b6a529afc6d328a890"
    sha256 cellar: :any,                 sonoma:        "837f5ddc5f63c261819c051b6c38714523e006b920de1d12111fe4b3b8ff8d4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed28a95f657ebfeee656fde98cfbdcb958011fea091dd33facfac5227625cbc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00dfad3adb0a26aeaed8c77278877ce9d74d7ef522038b1105126d12ebace9dc"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "gd"
  depends_on "libid3tag"
  depends_on "libsndfile"
  depends_on "mad"

  def install
    cmake_args = %w[-DENABLE_TESTS=OFF]
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"audiowaveform", "-i", test_fixtures("test.wav"), "-o", "test_file_stereo.png"
    assert_path_exists testpath/"test_file_stereo.png"
  end
end