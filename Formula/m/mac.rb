class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1190_SDK.zip"
  version "11.90"
  sha256 "6aeb626ba379af91b69a76047d5fb6e8f498630fa4274f865eecfd2b5ccc74d0"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6f6ddabe01a238594186162aa3ab3ab0f374fb3f127f773fd66baddf3f2ece02"
    sha256 cellar: :any,                 arm64_sequoia: "fee9c6e9d5acbb05579593cdfe9e0974e6e9f45a1e2f2b7386aa35ccbbcd0cea"
    sha256 cellar: :any,                 arm64_sonoma:  "99b38fe35ad6040ff5a67d8bc3340bb5019b7460b5dc836f08a38be14eba753f"
    sha256 cellar: :any,                 sonoma:        "490af2c118bf9e48a3e8da9f74a4797dfd55392a4292c30488e57af060c26dd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f18421be3a456704173d12acaf7d3276f3edf0336c517b2cb78a381a22697a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ca490b527e840603436f219f7119b4149e547ffb419b3e60ce0558ba9ecd4c4"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"mac", test_fixtures("test.wav"), "test.ape", "-c2000"
    system bin/"mac", "test.ape", "-V"
    system bin/"mac", "test.ape", "test.wav", "-d"
    assert_equal Digest::SHA256.hexdigest(test_fixtures("test.wav").read),
                 Digest::SHA256.hexdigest((testpath/"test.wav").read)
  end
end