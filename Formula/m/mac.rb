class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1209_SDK.zip"
  version "12.09"
  sha256 "b4628d585fb056c0c23c55b83d434e000d72129baf313d6087a696bb84e30dbf"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3b00bef2620eb48b4b69543bd1dc336aa7fa9b69fde107ebe49071cdee1143e6"
    sha256 cellar: :any,                 arm64_sequoia: "a93e49a9477e2547765948f7a3058fcd36180b6544f5d0b7488b002b3390479e"
    sha256 cellar: :any,                 arm64_sonoma:  "9a191e04c8e05b5bafe3705e97245979aba317ba4812cc83c91c916d6a420b1c"
    sha256 cellar: :any,                 sonoma:        "3ffd611bfa8ed53067c57aee5f7a69dd9297f781290d23c347be0e67601d4796"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8ae9f3c5a6cd64ffde6f9e28ed667e40aa623eae76f44c903417704cc015092"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35405a4e03725564d84c721102f42dc146ac581458019333407b763315e3b670"
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