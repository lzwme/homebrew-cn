class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1171_SDK.zip"
  version "11.71"
  sha256 "51665d0d3fa6ad3969b2a2208ef7568b0f82c1c2f99710321d50d1fdb31ae6b6"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c7befd5527dc2875d2a9cfc6572860bbd0a8a5ff0c78742eb0190b710b0e6e75"
    sha256 cellar: :any,                 arm64_sequoia: "61e67a5895fd9ac3330ac5f137449e483f417e9b1ff558d11109f3fafe5d2d5d"
    sha256 cellar: :any,                 arm64_sonoma:  "6a1e9de91691af688b603de2be0e9e0c25234e726fa65cfb2c6676070e9a5b97"
    sha256 cellar: :any,                 sonoma:        "ca5b4802ada28dc28fe34333593b35a54d4d287b3c09587968c9ebbe6093dc74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99591696c0634ce44c0864c728efbb2d815b558f8c4e9e82bb1b4503e6933df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1585266090ab15c38419e55b413a73cb40aab4b6bbb434e442d247fac4947fe1"
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