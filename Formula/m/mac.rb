class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1327_SDK.zip"
  version "13.27"
  sha256 "c47c6b36f6a7bd50d990f2eb36a70915c0074a7b9634be396c94464905e76686"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "de2238dc6fb0878b46a280682a552ab5cd03a5433d7dcd88ecbb0053607142b4"
    sha256 cellar: :any, arm64_tahoe:       "29555fae447ef44312fb17b234b373f07de08c673cd1d2935870dceda1aab07d"
    sha256 cellar: :any, arm64_sequoia:     "576dbc3fd410898300a3cb1d152231ff08d1c5236cd9890c0e82d03fcb9f951a"
    sha256 cellar: :any, arm64_linux:       "2680e3b39ce2d4287b30c83faf1daa8e3d9cd711ce9c10a2bcde4a53f1c0bdb1"
    sha256 cellar: :any, x86_64_linux:      "b2b38c77fd0c370cf8bfa6a4e64f4119f54ef2e51a88bb54c446b5606f35d338"
  end

  depends_on "cmake" => :build

  deny_network_access!

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