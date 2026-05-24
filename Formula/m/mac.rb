class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1297_SDK.zip"
  version "12.97"
  sha256 "da16b4e82a74188cc4f6a2ea53f353a640286fe10484e209379374df8962db5b"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4b140bd3a920cc400a670716e05b9c20b9a44290954553f1c0f91e7f5884d5a2"
    sha256 cellar: :any,                 arm64_sequoia: "7d3e5b5126f4734b07688379b6ead6ad8d4435374c81b0399c47ee6a9afca38f"
    sha256 cellar: :any,                 arm64_sonoma:  "2afe60f9f10e4343609361ac94849b35bfe0d9891225f11ddae986f8aa88b66b"
    sha256 cellar: :any,                 sonoma:        "d701b3b9263b2e11d03b4fcc7fad58005169d78374a4889d5de43d42daab8513"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b55104452c3a2b3ea28163c7002ee157229e52250808ed9255e0c1ac2791f257"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f9044eab43990e9502fe2a52799b53cb136507c83a2745a4ff207d2ae6c5ef8"
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