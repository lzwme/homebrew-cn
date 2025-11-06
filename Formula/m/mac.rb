class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1181_SDK.zip"
  version "11.81"
  sha256 "0b3d075b742373996a1214b346871073b55d83f79a4fd2f2bcfa17e92a8a1744"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "677d84a7ba6f261204bbf5436448c8f02c26c8a95ae0a7d4f01a2569947e2f6e"
    sha256 cellar: :any,                 arm64_sequoia: "0b788825e8e0ebd8e8a60aaf511fc36e19e39d5fd4dc178b4cdb188cbe115b71"
    sha256 cellar: :any,                 arm64_sonoma:  "ff5050b9d147c53170cf924e57c2fffd931976794f7b84890822261e088af94a"
    sha256 cellar: :any,                 sonoma:        "047e61e346544cfa8a27d60ce4256b28f4ad99e9772d6720a3c5281e67f2a838"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80796ee262168320c55c415a58de7fadfc6e7765928f254f5be2c5076023f0d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d771278dadcd21cbd63e23d985399ac0621213339dd3b1ea169789ac956d0cb5"
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