class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1119_SDK.zip"
  version "11.19"
  sha256 "3849ac1324269a9934a83da1549b8f56f894d5b70f41cd332a8d8893d42a0fbc"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e7a4cef017c8e8a0fe26997623eb3e27f219dc3700ce0b80460cbd051196a537"
    sha256 cellar: :any,                 arm64_sonoma:  "bff4883b9926793850a4a6b559f03721cf694d8ed706f7ec054c77cd2129d2dc"
    sha256 cellar: :any,                 arm64_ventura: "75143aa43e10791dfc7b6c9b179ab988856636fbd5fc011603aee8cd2a513809"
    sha256 cellar: :any,                 sonoma:        "87da1987e957c4067cfde9f9a7bd572150ce8c86ad764f4c1ecd4fd170edd7fb"
    sha256 cellar: :any,                 ventura:       "13c68e14e859637c4636c129207f8f7c51b836c8a7a26d347589795aa52a037f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd357625bc94ca71e38f42a1108c47723b8f616e766750646bac539109156104"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b33e3dc8c251083d4a4962c2cd1171b9e74765bf2726a9915ccc2a206ed01117"
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