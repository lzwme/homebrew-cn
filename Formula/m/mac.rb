class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1250_SDK.zip"
  version "12.50"
  sha256 "ead680463cf23cce0d496233497e0ec9e17d1fbf98f728983d84f957ce858f66"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "881b4ae73a36f7abef37bd545a9987594e58f802de43fb654d0d34bde5337dce"
    sha256 cellar: :any,                 arm64_sequoia: "3833f4599088c405ce6024076b20bc13d3c544786e9ee64848c368cf65350e0f"
    sha256 cellar: :any,                 arm64_sonoma:  "01b8ac2a60ae17720e89c9068bbe580a1d72904daf14839ce93064134d7f640d"
    sha256 cellar: :any,                 sonoma:        "b9be73a6587512fe86bf60038bb79c514742338ed5bd0c2ab6b16bad011bede5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b77c630a30825a9770590dc4165077b513629b347d1f6533e34f08a100401b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0b38ecd6383b268216758394d78888e3570a2c31382bfdc23e95dadbf74af83"
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