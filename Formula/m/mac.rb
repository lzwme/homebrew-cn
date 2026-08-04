class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1321_SDK.zip"
  version "13.21"
  sha256 "15e899dced1405e7df00de74a7224e6d9d57faa28506530400e8098969561432"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d1e24bbe8ab22f31740a2c95b506307deaba3bbff03a208e0306e850ccdc4e97"
    sha256 cellar: :any, arm64_sequoia: "0ea582f2e95ac67aef23971698c61e0b6d79676dc37ef40f40f4c1aa8f7a9109"
    sha256 cellar: :any, arm64_sonoma:  "b08f0838a7a5f5ea023ae33cd50c506f8a1fc4e3d66cc936b5e457056e9512fe"
    sha256 cellar: :any, sonoma:        "71140c313fdee191e3230852b515a74b362ea4c011c319b0e1e22b1d9e9aaf3e"
    sha256 cellar: :any, arm64_linux:   "a91271deaa2003228bfd32d99f286ea15cb87475ae8dd7987dcbf420b27348f5"
    sha256 cellar: :any, x86_64_linux:  "73644df7e4d1e0ca42b3663642c9cfc0f7bf180e46853195710199edb5f2fb16"
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