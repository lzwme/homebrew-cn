class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1118_SDK.zip"
  version "11.18"
  sha256 "843b3f2570665a23b50b43dfb6f0fcdf58b992242ab8d0d17f9cb65167aa9c37"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3a2a9a2396303fd2ce1d219335ad6833edb82b20834de2aff87590cfa716fb62"
    sha256 cellar: :any,                 arm64_sonoma:  "d4034bea9b08ac0612d88b0d19cd9b1b00eef9c70031772a4826fe8c32641406"
    sha256 cellar: :any,                 arm64_ventura: "4cd51298124c6a1701e1d9839a76185f9d4c2dd349f627b69c0fe514dc7380a4"
    sha256 cellar: :any,                 sonoma:        "2da0483897b20eabab41c330d4a54bd7e82bb76f54038583a124b80379c64a84"
    sha256 cellar: :any,                 ventura:       "579237665811ec2da3561186278893480c0849fe1a5ce5292cae0165e230d27c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e216b2382a8e1b71858c27d9ca2439e9ea25d02b8c1a0b904ffeb1fbb4613f57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87fadf859260bc262cf2e2ebdce05d1470a28d582f5ca8f464ea2cbc13810b05"
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