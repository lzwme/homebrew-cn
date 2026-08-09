class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1323_SDK.zip"
  version "13.23"
  sha256 "62f8826988627fd997fe180fd040ed9d1daeca523ca1688fba1ae7edc010a814"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ec713b628f623b847ed45434dab33fc27d33ec9e14ca5fd68a03df3abc7b0dbd"
    sha256 cellar: :any, arm64_sequoia: "78639a0bb79e6024fe295d2c056299e1f04c909ac1b9fe8bc096c0649f1d4a0a"
    sha256 cellar: :any, arm64_sonoma:  "6c61d2db945d33507ea148ce5c08838ccfa68002cc737aff51e394fc96344a98"
    sha256 cellar: :any, sonoma:        "f3d5987d605b70ae1953cbca42cb066f20a380f11f268eab4beac0ea6e2d2706"
    sha256 cellar: :any, arm64_linux:   "0eb544b4da7bb578878fbf58d082706aa19c553ef584d0a9d65cbf35ddef8fe5"
    sha256 cellar: :any, x86_64_linux:  "0a725af9b2ec8547015931278121582574152e67dd72815876bf2b3798805ecf"
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