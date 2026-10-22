class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1342_SDK.zip"
  version "13.42"
  sha256 "0a763b3592d13183bbd6c04b12eb637d364de16791602733a897b72df8e87326"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "aed9114ef1a73593ec80a802cfed0a11bad6ee34ab0b43546f04eb65b9f1ae28"
    sha256 cellar: :any, arm64_tahoe:       "7c05beee6f2b170664526c7bde320e11ec7cdeb2faeeabc7ee7cbc618fde2527"
    sha256 cellar: :any, arm64_sequoia:     "e34a4253dd57c390c5e4d0a84f656aa56093787594abe8df91d893a3a5edd49c"
    sha256 cellar: :any, arm64_linux:       "7d523fd4f81a11eaa8ba0e3deb1a6e256743d57f67f009ade760716ff6f881f3"
    sha256 cellar: :any, x86_64_linux:      "6b041f9ba88b416c33bb83b742af5ba4754031c5ad0d9c95687faa406046292f"
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