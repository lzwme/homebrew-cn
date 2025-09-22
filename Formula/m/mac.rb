class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1153_SDK.zip"
  version "11.53"
  sha256 "46632e3f9e15a9c7ab5d05759e86dab5619bcca4dcae9a394727b29932d65fb3"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c3c850bcbdb569adbbf10379d958cd0176f2d6804f5a2bd5bcfeca3b0779d324"
    sha256 cellar: :any,                 arm64_sequoia: "ef8e49b7ff2c1b6760ae355fb9c4ee3e110c72084d2c4c9241eb0d6cf0ee21e3"
    sha256 cellar: :any,                 arm64_sonoma:  "ac4aed4a69dcf9933bbc344386c732819e4f3def0a0bdc4bc6b17be17b27c6a2"
    sha256 cellar: :any,                 sonoma:        "fd23b9b971528f88434a10e5d553337e7ee893c325b6891070e06af4e1247705"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b220a7869fd5b661344d7ad667a993f29f77cbf841d35d9476fa33d3b6b6be9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2b6f01dc662e3a4b6af2d08ff65df15fe29c0bc6de1baf2698a937270ee39a1"
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