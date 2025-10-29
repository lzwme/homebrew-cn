class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1170_SDK.zip"
  version "11.70"
  sha256 "b79fe021f23107279721cda750a8686a1790a4f7cfb4b3acceed9bbf778025b4"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4ffc167fcd5574182e6299b33d3d15c04bc627acc58b583e4effb8fb4442fd50"
    sha256 cellar: :any,                 arm64_sequoia: "8b0e4bc5e7b43438f6a7a32bc4ab892f97b149b9db4b43de2d28293db22725c9"
    sha256 cellar: :any,                 arm64_sonoma:  "0fd501d5a79e01ab1588658066967191ed157ef30f5501ab61dbabe2679cff37"
    sha256 cellar: :any,                 sonoma:        "4d7a2c590f335ba78c14efaf018a7e573fd1387db12ee5615b5b1d64c3560fce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f5449ed7ed9b23974491f8f904f2dfa6761d15c74379d07d90ad4055965db06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4206a9aa53620bbe115157d134f0b911b490a1babb4bc9c285f12628d2e24472"
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