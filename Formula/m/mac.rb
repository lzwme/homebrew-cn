class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1319_SDK.zip"
  version "13.19"
  sha256 "88cfc81300ca33513cba48e894ecd89c2e997257da7b29f8411a73251e348340"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2f676276613c3f6e5f178cbd78c70064372cd921c765d863cad8a5c441a1ca1c"
    sha256 cellar: :any, arm64_sequoia: "2eb18be7c7de9fdbd10219b9e33c98fb5457d0f1bb638f7b1ee82b49c77dc3e1"
    sha256 cellar: :any, arm64_sonoma:  "cd9e0fc8a92465acf65573068039cc60682b626757b265b643618122a88aa298"
    sha256 cellar: :any, sonoma:        "6daafe6f3f5ea7901f41eec0b13a3bd548b0e5a09d94fc6742f1c423458127d1"
    sha256 cellar: :any, arm64_linux:   "c92f5a379489a019b2dd8c27f239cb229c17c7701d2252eb032864bbbfc791b5"
    sha256 cellar: :any, x86_64_linux:  "57dafb948e0c0271bc14a8a138aebc8cb7438b55fd8967551eae5771d3597183"
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