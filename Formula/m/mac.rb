class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1330_SDK.zip"
  version "13.30"
  sha256 "9f74ffc0300d0b664e0530186d543e060f50e8776ae9325ec7b3f8fb1eb3f230"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "aad1fb7773d681fe4fbb0a84ad8f5e2a4a09cf0c858dc20ceae86a55be740f25"
    sha256 cellar: :any, arm64_tahoe:       "7298cc9179bc9da42eeef7537aacc48111be720ac730dbe98d61e1d6a0e1c578"
    sha256 cellar: :any, arm64_sequoia:     "03ab3ba8ba99cf7fbb89911634d3fa31c0e38fb79e3e52121c1c5d86b3da7b18"
    sha256 cellar: :any, arm64_linux:       "918891bac34797e42c94cc1fd30cf02648077505f923da4173b56a677a855d8f"
    sha256 cellar: :any, x86_64_linux:      "2b0b97235066da304c7ccb4366f3b87d9a58c88dc049133c37481ae760f4b920"
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