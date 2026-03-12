class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1251_SDK.zip"
  version "12.51"
  sha256 "32489666d838f92ca2914d0f5e6a91ee8e4ba08df03e5ad04c852b3bce8f81ec"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2b0c59f7b6b722f8fbc539a5b8d7d946bcbc0a7161a321ee65269624a619d712"
    sha256 cellar: :any,                 arm64_sequoia: "17d8f62d986d1a86c5d7b546328ee79b4c0c83ba67c3742206af8a14bf281f25"
    sha256 cellar: :any,                 arm64_sonoma:  "eafc8fca6146d4659373d53aed65999258d1e4c17b81854936ac73622d56c2b7"
    sha256 cellar: :any,                 sonoma:        "3e3d03cd851a82860436cdcb8dc35c8bf56e46a707827b30e0dc235dd1fa6513"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f27fa54cfe662ac6c779a27e3438838bc81b81c738a9da5021d24dea69f04f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b10373d2875b01aec6caf4b6dfac37d47536dd236422f774fab824a3b6bb6e3"
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