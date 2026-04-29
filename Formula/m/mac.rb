class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1275_SDK.zip"
  version "12.75"
  sha256 "eb28fdb383dc115621449e66522260ad6f3f533d22069d79675decbb7971b662"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34c4633a4571949bd419e533cab55804bd4d775ef0d11c0a71282b365d5a3500"
    sha256 cellar: :any,                 arm64_sequoia: "37610b5a761f0ab33ba1f7764a9866fd9fe8ca12bb6b92d907cd9b7da65a0165"
    sha256 cellar: :any,                 arm64_sonoma:  "4fd750277ea99667d5afc5ed162a90e50ae315b444d8ddb6b9e0bbed34315a34"
    sha256 cellar: :any,                 sonoma:        "5d7501eac2f027f35ff4e0df69f2c87c3accaf6f123148a0b0f5677f0db33528"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e378f7b30f7bb0ace0f405906ef373800b14bf48691bccf6d18eb769f5bcb036"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34853db519c39933a7f82fc3310ef3254676b636029b7b228f0910156a3d62da"
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