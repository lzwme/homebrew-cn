class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1288_SDK.zip"
  version "12.88"
  sha256 "23bc6cd9518b9aab4d6ca853ec36a3a14472d28bcac19a23db7ec5a848166d9a"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f049ea13f9026ad423d23a72fb034741d9d6e4884a915ced9e80ffab7b50633"
    sha256 cellar: :any,                 arm64_sequoia: "54b7c63889a0011cba0416031c33040f237f64bfc8aa5f13b1757065d57ce94a"
    sha256 cellar: :any,                 arm64_sonoma:  "98de7c5d6c1935839364e879e96fd1c97c959a503455062512428c29731a2c93"
    sha256 cellar: :any,                 sonoma:        "82cf14c9e0cdc52b48dcd2cffed8005ac8fdd7810ef9dc5ec06e47fa8e043c3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f31df55dbf015f0e1f8dff5f85280eae0baddda362b4fd126f3d8bc5e25fe419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62e0d598b2e9e33cae12430c4f38bc7941394aa89baa70f41e324fad86894283"
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