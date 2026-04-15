class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1265_SDK.zip"
  version "12.65"
  sha256 "59200044e850082351a5c789ea6b46064d1302555cd944595b6a08660b876b62"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b374bd68c5f4a0dbe2d649100646b8888d3a547da588bc04443da84952e2b53"
    sha256 cellar: :any,                 arm64_sequoia: "bd2956e7bb49fce72af540dad0ef845e5ded0dff902028f85a09a78fe964a3e3"
    sha256 cellar: :any,                 arm64_sonoma:  "594f95bff544e4c95b4bc5a2d19744414b586f8c79560cc3c2a1068da6eb4adc"
    sha256 cellar: :any,                 sonoma:        "414a12fb0a4d59a2261222bde3435997ce0121aab24eceae3f16fefb0b2c299d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d635fd5fe8a58e5893d501c6f0c1ee5ea4a41ff3af6432cb8583ead7ef452ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab87b3f894d2b21fec9d5298bc7f216cf4b924f095ae06f8bcc0fa03593f7c20"
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