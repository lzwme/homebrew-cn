class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1185_SDK.zip"
  version "11.85"
  sha256 "672839857f43a68fa0a031de8048cf40d59e580d1419753a2bfb97c2df17c92f"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "99edbd639e5e1aee547f19f4bf09f7515f13fbefdb38fcfd981252795e740739"
    sha256 cellar: :any,                 arm64_sequoia: "1f92ba7865075e14341536e456b04bc6acf863b61c2cf3deeca8397eeb9f1ccb"
    sha256 cellar: :any,                 arm64_sonoma:  "12188951143ecb77725c1286ae4fc9e9d4db9820ae3192de7056eb5700a8e26c"
    sha256 cellar: :any,                 sonoma:        "cf0c3eabda70aa44448d74b5c23a9b4be0fca503e7a237938dcaa6f01fc28d93"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ead53788f259fb381ad567cf3ad39dc6e34c0556277d7dd5bff3ee6c66b4be4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "329feb54b1ee29f8e09eab3b7c38e13fdede98636208bb55f8eafcb8f6a47466"
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