class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1162_SDK.zip"
  version "11.62"
  sha256 "9945408555424f1f81d69d8bba46f191331219c144b7576158f1e4d9cff67024"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dcc21cc1277f4ce38bdc958331a54f71de921381fc9beb76a59be597c781fc5f"
    sha256 cellar: :any,                 arm64_sequoia: "b4f1e3740df9f30f3d76a6634dc6a6ee91c31e4a46cb7bd2a904aeae247885ad"
    sha256 cellar: :any,                 arm64_sonoma:  "d3464c419b401fd13a42983d195ddf29215ecec55021535667fbf90545f42061"
    sha256 cellar: :any,                 sonoma:        "d47747facee14c7e618527758b642e454ddd2f5c1c3af2a3fc868c3f33916ebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "830777669b7a5deeaee6f61a29ce302aaded59796bc2dc166359afeadc1e276e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b64f1a323786fcf4a8970ed4730c6a2da09cea8e0bfac67996fc87f428426ba"
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