class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1112_SDK.zip"
  version "11.12"
  sha256 "1dc90edf2bf9820227b6ae69f5a7d4d5df80d2c1458762c671758b0d1a132d0c"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b8837d96aa02e91f56c72a6ac4ecc75c673b1bd9532438f40d21dbb3656416d8"
    sha256 cellar: :any,                 arm64_sonoma:  "45982e8f073e0fe8675f732851c21990b9cde82069588d33fa6a27ce69239079"
    sha256 cellar: :any,                 arm64_ventura: "3476a3f2f398f30f8434a938587be34c0b7b648d18e42f64db350726d6c46bc1"
    sha256 cellar: :any,                 sonoma:        "d6f8feee06a54a05b528f07be86fb2097802615b6c5398d84ff955f830c04b09"
    sha256 cellar: :any,                 ventura:       "47d37a7471181d8fb80e9d5e15aea6754e3981bb347c8fcbc5a81ac74a9d5767"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95a9d55bcbe0468a055823f343dc1ea0d8658289e4ba1ec8053d310872b853cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f29e91e8b8907ad1eb73af3264ae51505dc39638b3465947cd6d5648c551ab1"
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