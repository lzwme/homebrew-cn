class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1132_SDK.zip"
  version "11.32"
  sha256 "6055ee2c6cd714041e08b42d24dda254e3a2f19a014dd1ffd40e5b4a4c85ac9e"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c55a469e856d511fe12bec5b2cc0262e883eab16027d890590b1ce107d75783e"
    sha256 cellar: :any,                 arm64_sonoma:  "e362f34fb5e58b54a19a50c259c17b76d8b782a2a1442054f065996333bdab07"
    sha256 cellar: :any,                 arm64_ventura: "ff27c77a9cc6b14933445926a26c1ad6224801e35c8f5ce13d2646cf3ae7a607"
    sha256 cellar: :any,                 sonoma:        "ba4c0fbee53ada7d8325fe15b65b1144d1d98de6726732e7f9ee0ae5c96cad53"
    sha256 cellar: :any,                 ventura:       "62efd3fd6c67f233d55df08e6896dd57fd1e8845ead40a2336c8ec4fd8387bc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d7ea6ff5bdf109ef13835bd640a9b97af8d6d347650d92300bf475744a44ebf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a54d9d54e0d7ec02a1f4e97e7f00dfb1990fb0ce40f9200ff6b7e16097b06aeb"
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