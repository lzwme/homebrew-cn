class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1252_SDK.zip"
  version "12.52"
  sha256 "78444443b8dbffdd9e86a10aff7cc6e444146b36fba8ae70bc83bd5db18dde23"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2240f12e3a417deb85cf00db667c80a53a4f9977bb8b98081832b7d4182a004a"
    sha256 cellar: :any,                 arm64_sequoia: "da0bea5e1a764816afef3df9260a541f52d1c8e50ac355e786f0e36fd479adc8"
    sha256 cellar: :any,                 arm64_sonoma:  "c3b48e17a217db7a2bb5ee750b20f8f87375c030ae971e391d4cae6bc29edc33"
    sha256 cellar: :any,                 sonoma:        "e18a97c754922fdbf460a317487b0a7253d55a7dc5dd67f7a83de088658de40c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3dde13ecf7c2a0b9b145eea6c2772377404c70d236eea8ae52d02d20150cec1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "727538ff1310bb8bfd1f49d0e471e6fd78ec9c84bf132ff38963bc3bfe7f8a50"
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