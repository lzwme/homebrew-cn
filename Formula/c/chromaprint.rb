class Chromaprint < Formula
  desc "Core component of the AcoustID project (Audio fingerprinting)"
  homepage "https://acoustid.org/chromaprint"
  url "https://ghfast.top/https://github.com/acoustid/chromaprint/releases/download/v1.6.1/chromaprint-1.6.1.tar.gz"
  sha256 "3368805af0ee47b9df74df10b5001a44569e01df2844dab520031720dde9ad23"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "41d809b84ff08b6041ebb8d8145362ef4ed5d6b39dcc9ca722926a6b0a989d37"
    sha256 cellar: :any, arm64_sequoia: "eec71c010dd50027135f1962f2837375fc1ba31dc5d744e070547718946c9980"
    sha256 cellar: :any, arm64_sonoma:  "d0986aaa88db13f2422d0fda2cd8fd3def8f17c628173f5e8529b098c75e639c"
    sha256 cellar: :any, sonoma:        "e538e18809a4413f8a4d24c1aa1329543229117a04f5a70a2d3e46debe445c96"
    sha256 cellar: :any, arm64_linux:   "d0bfcdf6f5378c517e4984d18fc176b37d9c378a830dedf5ff77e4f07c4841aa"
    sha256 cellar: :any, x86_64_linux:  "4059dd2e35d812d544a21e9c46cb46fe8881a5d3a78f45a8857bfe5b1c1962fe"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_TOOLS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    out = shell_output("#{bin}/fpcalc -json -format s16le -rate 44100 -channels 2 -length 10 /dev/zero")
    assert_equal "AQAAO0mUaEkSRZEGAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", JSON.parse(out)["fingerprint"]
  end
end