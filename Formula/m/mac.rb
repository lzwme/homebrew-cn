class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1116_SDK.zip"
  version "11.16"
  sha256 "97a35eb11bbcc44630acb7c3d5d717d6d1faae05a4a2e526bcf4004d74fa0161"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "553e5234c5957fc79305224ff38310ffc7b23c424b11ab84cd0a5627e02ec6e5"
    sha256 cellar: :any,                 arm64_sonoma:  "d2609a22906036d14a028e10f6f11241b527f03c76db4134e9d7f5a0f27db1bd"
    sha256 cellar: :any,                 arm64_ventura: "2190a5343904ddabe4b81d9ae4e7eef4cfcddc2f36595012a71c4dd58679a6bf"
    sha256 cellar: :any,                 sonoma:        "885b3cb98e01f63f992b54e99eab64ad3c6d3208ee8dd41fd34de400db541310"
    sha256 cellar: :any,                 ventura:       "80c527bcae2f79551b9ccc9eec1c10f47b48310b124e31a7ae73573f3ad49c34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3a3d95e7fb1b1acaf60542f7c42027927a378a961154daa9dc2c2099cf72cae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c52fa895c5bb050c224cf966b6949f38731385e8a1b0494ec656f88826ac75b3"
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