class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1140_SDK.zip"
  version "11.40"
  sha256 "40072a14a8b2b027964ae91368a008717f9ebad34f6f25a70cdf87fc0d68a4d9"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8cf13bfe43e6cf63aa109878405c1325407ed718dbd5333e76c9012d97f6eea8"
    sha256 cellar: :any,                 arm64_sonoma:  "000deea6e6a3f14d31a6cafc0b36fec77480a881ed77d5c6f96e1791e0acce65"
    sha256 cellar: :any,                 arm64_ventura: "76e91787e5d24f0042c281ba25224ab28b53afe7b3ed331b1fd2fdd955f3bda1"
    sha256 cellar: :any,                 sonoma:        "192283d9e38c54a784dc0d23e5eefa13a4202f1d573eb11e8a696254ee9fc45e"
    sha256 cellar: :any,                 ventura:       "1bba792e2ba0bd3321d1d868dc60f51886b9855f47f2e618b737ce8afe51bd92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6872fda90514602f76685b94a383ff5a0bcd86f7fc2e040b3a9f6584c2d55628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d55a9003c767559c55c36b20bec89b05f16a16b46824267d3af374dcb38941b9"
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