class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1266_SDK.zip"
  version "12.66"
  sha256 "15eed6e19392b18393871b1986d233121b0ab84b80fda316cd07b47f900d4965"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8cffe46227ab828b0756c84f037701327a1b2522181d984a74c70c49c3fd8e85"
    sha256 cellar: :any,                 arm64_sequoia: "b92b6fad0148636bdb59a26cd7c3163b7b8ce274b8d4bca02789155f86218b3a"
    sha256 cellar: :any,                 arm64_sonoma:  "739885c6c6ee204e78717267a2db14e1ea03f27e5ea3fa8013904350481a1078"
    sha256 cellar: :any,                 sonoma:        "4984fab2a87a0795612c9a61d4a66c56313867486e9f0fbc2a5eec2879fc313c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24691ace1fb2e7a5efdac34126b31a6b5bfcd810690bb3046812c3f853614b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "290bda841114e0ef941b2d97f1224f5721e758e0adfd4451cfeda7e3e1c02a3a"
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