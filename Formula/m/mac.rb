class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1214_SDK.zip"
  version "12.14"
  sha256 "ae593121f77d879d3c2240437a4cded80565e157820da9c3da9171064a345666"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b1afe58cd71771e830b54adca8c380915836ad2768f15ec4c27705d9a354f7da"
    sha256 cellar: :any,                 arm64_sequoia: "0b36de445af08ed2546334474fb634018e06f98bdb3d54ecf90f499db5d6033f"
    sha256 cellar: :any,                 arm64_sonoma:  "a7273f78ff5c0e38df601697fc44d80ed7760d43338755a41dd36ea09ac700ce"
    sha256 cellar: :any,                 sonoma:        "85f5526a2b615c02031251888972de566fb84567f459ed3f5a3d988286a66505"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ca13c928c2239c4bdc600283df38e4f0115a78c7af326cfc3465b76dec1c303"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30d0ebf69ad6c573123fc56b1ec487ba84c0ce12b703670af280d733d545ca70"
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