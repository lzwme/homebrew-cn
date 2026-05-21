class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1296_SDK.zip"
  version "12.96"
  sha256 "57541ca9bfe467a50496e28aa622857f2deceddee00c7b5b6d3d515950da4256"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8722996169d2d3d5d66699f8fd49393bf3e60b9aec269f10e3dcb20defb38eff"
    sha256 cellar: :any,                 arm64_sequoia: "25cfe12add78aa791c4d12fd38ba952c9f769f8c482a2fa938326e5d4a854531"
    sha256 cellar: :any,                 arm64_sonoma:  "31a442452489cbcb389d155bc5968cbb283161fd28cb0dcc1d46649a38b4a2f7"
    sha256 cellar: :any,                 sonoma:        "14b3b5bb752119477322e76e5504e2b17ea65b8427a02537d9f75e7326004078"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cbf2fa2d7cd14f06c74b53f5bafe434a88deb0ad57ca682311c81f2fa11e966c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf2eaf104ada6f041013d7aa004ca7bb4071561b444729e52c60f951764abc77"
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