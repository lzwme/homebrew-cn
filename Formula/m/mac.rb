class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1131_SDK.zip"
  version "11.31"
  sha256 "70e47891b8b0c364c9fc9e9e9d854d7d6034f50e4b47459065e6c900ba7332ef"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70a5e340344656f535db50be1fac56f3c05a4a24d92459cdabfffa7826ef9866"
    sha256 cellar: :any,                 arm64_sonoma:  "9a36860eec1987cc6b6d8bb3345cfdbce6feef9128da58b98b3ea6885e40fc8c"
    sha256 cellar: :any,                 arm64_ventura: "d4192b30a1d17d98962e94a46d8995cd42999dc1a4d4a0617c014d56fd139fd7"
    sha256 cellar: :any,                 sonoma:        "578cde6d1a243ddd0330b61bac9f0585a793aeb197f2c8e91bdcb4d4362743c6"
    sha256 cellar: :any,                 ventura:       "71f5c85080f6bbd1bd74fd553ed69867eae3e8211b9ef442b44e2de8073388aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85156f5564cd950b2f0a124362839a573d7499284e62605a1fcaf380898fc584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5bf2de2f19d952be9ef7ee2fade4ef6203278e39e35837600761b3f5824e1977"
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