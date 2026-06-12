class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1304_SDK.zip"
  version "13.04"
  sha256 "5082cc873dce3b77cdf294e2ccf9e54a326aa6e9f0c3fc8a05cfaacab5744afc"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "da2fe0a61b72dad8a00f83d160f21cf01a3429448ba01df1ad7e641d7926e98a"
    sha256 cellar: :any, arm64_sequoia: "94bec55e717a9ec5a026bd54b95763ea1a43bde44617c76841d7132c5ec4abc1"
    sha256 cellar: :any, arm64_sonoma:  "de9c75529afd943b4ec2f46a29f3c29d0ba6fea8ff5b494ab49293d9b448ffb9"
    sha256 cellar: :any, sonoma:        "600406ec77804fe3ba14e02c59ef0c52e4ec4fdf4769c768fbdf2527fa310be4"
    sha256 cellar: :any, arm64_linux:   "884df9213d7baea1bbced25a1e3deb6ee06b91ab205547c204bef4ed06075ef4"
    sha256 cellar: :any, x86_64_linux:  "9b287abd899e98a70aa218142cde95e0d42b6d50e3c6a9fab11f9d72b78a348f"
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