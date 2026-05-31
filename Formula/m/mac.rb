class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1301_SDK.zip"
  version "13.01"
  sha256 "92e735181c3dcd6ddb7c98078f7225e2cceb9fea4ec961f6a1cd3c530afe1195"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e66fd08268e50736307eaa27faafb53b08094c0ee6304072c28e2960ecf1fb91"
    sha256 cellar: :any, arm64_sequoia: "f0590f053a6a12d92008e2f8f1af191f01a265c58ab4949c8b9f83727586997e"
    sha256 cellar: :any, arm64_sonoma:  "064ff254cc7b5ec842be6f29a5c0c9f51f598e4f3fd714b7abb75249ec452c4d"
    sha256 cellar: :any, sonoma:        "16c637ff1b5de9bd2c632e04f1b7fc109aca25de4fa2ff54034ed3badf7cd3e0"
    sha256 cellar: :any, arm64_linux:   "199a8f712e849d3053174ad6f173748225887bd641a340dcbba09e651501055c"
    sha256 cellar: :any, x86_64_linux:  "1118de40a492261cdcaa11c6d3a5017bf1f4ca0a7430be384e8bdf360c60d705"
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