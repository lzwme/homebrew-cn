class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1164_SDK.zip"
  version "11.64"
  sha256 "67898dd446054c5d59873d983a01a8968cf0fe1bc72e4da2b38b7b89719dbd2f"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9cc951cea123876a98e56f5dfc068284fe906096a48403d1511a153d2b7c5577"
    sha256 cellar: :any,                 arm64_sequoia: "1285ca94cee2c31d11f248280b5e80c82a1d119e51d632864a04ef3fa1d550ad"
    sha256 cellar: :any,                 arm64_sonoma:  "a24fabb9f9f75b4b63aa6adf663a179a9843aab50fc52f34ad9fe7adcdb08ebc"
    sha256 cellar: :any,                 sonoma:        "72115547a265255fd1859664c3d7db8b0dbea9d3abe503716dfe20aae4dcf347"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c5dc1dbf5767391b999614e96075832b9ba8adfbdc80946eae0b8f9e0a2c046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0190447c8d70505e18d0c7ca943a09071baab22cef37cfcea2af29235ab166f8"
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