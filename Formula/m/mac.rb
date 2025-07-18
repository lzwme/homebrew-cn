class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1121_SDK.zip"
  version "11.21"
  sha256 "7f9dc5b463b331cff0686d78e4627ac6742d6705f10f3149105aff23b7ca0baf"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e61c3fc8e83ec7926db3fe301c935d0381656c141b2b0ba28b002961c5c0dc19"
    sha256 cellar: :any,                 arm64_sonoma:  "74c9811d5072922dedb1b42d9161ff97820e7823aeb7280dff7856598e41491b"
    sha256 cellar: :any,                 arm64_ventura: "91b14f493c64c314ad7e7fc92d650709c5452b18180209656269c24f831a8a5b"
    sha256 cellar: :any,                 sonoma:        "b62745d635f5606514d5bcc891ca239489a50679ceab6361570328f4318b7027"
    sha256 cellar: :any,                 ventura:       "79163c0d6be458018e2e8f6d4c392641e126f478335171a9264e7b9b66145e1d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99565c0c52fc92bff40414bd7165031a84fcde67c4e85239ea1d0bc4727326ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17383d34f3f4a2af3b77bb8c65631156e2fad432bb1df6856da4c0cf638f326a"
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