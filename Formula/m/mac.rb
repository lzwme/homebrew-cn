class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1328_SDK.zip"
  version "13.28"
  sha256 "2694a913053dbd79c10d3332ca4328e974d4b1d341ab1aec726f41bdebe500c8"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "40dab95493526ed7ff018d2f42cd151aa25523ece2be41c1e77809526767530c"
    sha256 cellar: :any, arm64_tahoe:       "e110b5bbbf2ef50a25de81630d746df2cd20eaece713a245bb29a0f416d02e35"
    sha256 cellar: :any, arm64_sequoia:     "b137b66a570b3a6d1e7c4647d5d1ef370da7e606dae19020dcabf7050528a3c5"
    sha256 cellar: :any, arm64_linux:       "8ef421b5aed1ee3439bcd10f83c6e841154f77af29a2efe8b4eed851c445ccf6"
    sha256 cellar: :any, x86_64_linux:      "a4f3e32298b1bbaa0a4061d0a165fb54c00413b3fc9b1b4e6fd841f6b10d3964"
  end

  depends_on "cmake" => :build

  deny_network_access!

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