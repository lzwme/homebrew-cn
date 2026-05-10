class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1291_SDK.zip"
  version "12.91"
  sha256 "d606e2234acf83c3bdc0427aa3b5859d91d421b4174265bdf3bfaa7be99f954d"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82092881312023a55bb556d0625ab1d76eca7ca412419131709c7c9999445108"
    sha256 cellar: :any,                 arm64_sequoia: "386f771d1e99d6b38b2ced8c7ef7c61db65d009dd3ec96e6d5c05b44d535736d"
    sha256 cellar: :any,                 arm64_sonoma:  "6c76531b5ed9e121979da8d963ce656aa11d5614fa67c76520c775ff4b8ad076"
    sha256 cellar: :any,                 sonoma:        "be547db8868735997b44c2a1e7e46ed3eec28ce9d02645dbd9625f11ad79f8c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "058cdf610ee97b133bcde20c7650649817816a572ed3ebd03d86260a0606d885"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c020a35d1f1758b5bab0bf2ffbccd7e7d81dd16d69db784519a6ba20248da3b"
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