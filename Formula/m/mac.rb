class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1184_SDK.zip"
  version "11.84"
  sha256 "39f4d6e67e8135441a5e6c7a3a890831ba041f9b6406df821170ef2c0786def3"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6079b985184980505af094232a0952469996cd3b6a919b9ed57664c32c327fbc"
    sha256 cellar: :any,                 arm64_sequoia: "30555c55749cab2c28fbd231fd918e56878e53dc06326db809d54ed1fcc5c88a"
    sha256 cellar: :any,                 arm64_sonoma:  "7ecc78828d53fed421ee5d6dbe5f95125fc377937da12b2ae09d61624cc53d37"
    sha256 cellar: :any,                 sonoma:        "5c56c5035243e975ba07f83118d18f5dca4b858ef4a07fb8bc3ce7fa2053f24b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78cf809abaf8214e2d4abf474483d5383e970172ffc7f201feace6b53194d92e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb0d899374a8f0a8b613b64745c249221624d95a28a2e929d5392af98042edf2"
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