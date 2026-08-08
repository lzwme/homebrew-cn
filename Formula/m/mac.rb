class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1322_SDK.zip"
  version "13.22"
  sha256 "b693738d8b6d7e2a779bf0d90c0310d2868c7afcadeb13eab2ed5abb559f5365"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fd227ec403837ffe5eb00267338911a563c936f344c319931128195f50429afe"
    sha256 cellar: :any, arm64_sequoia: "91d8fe832dba5e0850a9e41aea3815b5abd4e63b45429b0ed65cf6dff53e3255"
    sha256 cellar: :any, arm64_sonoma:  "83c98ec1787b8377c0f11ff148fcfa3ccb73c565b4784d0a9be48c6e3b823879"
    sha256 cellar: :any, sonoma:        "3f44f196902920127d983cb53059d0c1bfccf784986c258ab85b211e80853cd9"
    sha256 cellar: :any, arm64_linux:   "4a16bb6557e937794d32e75b6eb95a212772c451d7e57f75a3509ebae142fc33"
    sha256 cellar: :any, x86_64_linux:  "3a39a98832f72431a2d5a84a8e2333ad7a1e3bee252a127d9d10d185dc8417f1"
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