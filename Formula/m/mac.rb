class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1117_SDK.zip"
  version "11.17"
  sha256 "d6b221d08eb57028a452d06057b4cc74c5b5d47bc542aed36f5b79404fd16b96"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "50b7eb5c1001618179374a2842782c9b6a7e369b4055ab582d4e3e56e9bacaae"
    sha256 cellar: :any,                 arm64_sonoma:  "8799b9ede0d4e0c25ce23159f5039d221361d9dab2dd5fbce2feac6f4a81a208"
    sha256 cellar: :any,                 arm64_ventura: "a616bda4382bc62afbdae58f75ea9996af9e0473eeeabf8fab539e444d5dff49"
    sha256 cellar: :any,                 sonoma:        "8f0dab0a321b579aa639050b84933be468c9a20ebc2cde5b7fc2fbe87e16c445"
    sha256 cellar: :any,                 ventura:       "5ab3e0f0ef2e96df4e07da6a9de35f2cdeb16b910428de4468a6cdd7d62d8eef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a9c9cf6f716b858e399d83cd1f71ff6ab35a98543e712d649e905cf0f32c4b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cb6752bfd8b24350648b1328801be3978678424e854abb4cc0fdcf8bd56a7ed"
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