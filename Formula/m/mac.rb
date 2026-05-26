class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1298_SDK.zip"
  version "12.98"
  sha256 "50bfcd0fe4bc909439fc4fec0af209324850040e681ef726799b2a71db9ea655"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3fb9bf2e4498d103478a7ec6014de996dc3e6ca25fbc8676fdc5bcf4f9199d64"
    sha256 cellar: :any,                 arm64_sequoia: "5b63ea2daefc70e821db9c01e091e34d741e27a3ab210d464773b2342962331a"
    sha256 cellar: :any,                 arm64_sonoma:  "dda9f906a72e0e907e0ef9f7f7df166460e1abb668c0b13d66c1460b1986b509"
    sha256 cellar: :any,                 sonoma:        "d635ee586033a9f010f8e38b8c2974874356d682dc958b33be2bafc1a87c738b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e4b7c8d1d89dd5c2f717902397b44119707b61a631f3dcd994ba93d7a749b7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a22a9885bc8f95dd70301da38d6764edea80c1410a0152df79690f23bb4eee0"
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