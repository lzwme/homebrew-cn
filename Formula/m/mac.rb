class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1133_SDK.zip"
  version "11.33"
  sha256 "c6d92a73842eae6196a53c76fb11b8e25874477a812bbf65ddf1d74fba457c21"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "95f75c2f8a1a6f2d6260f4694c3dbcfb88253bdb8c60b046c03a2ed4c97656b3"
    sha256 cellar: :any,                 arm64_sonoma:  "0cd150af4d4a6aa56e1c6a014bd79f5712f0d41149e8f41e2c8c3e480dbf03fa"
    sha256 cellar: :any,                 arm64_ventura: "628cd3927ccb2532344e03a530de0c7bda69cd20a83979b6a4ece16c2ee549f8"
    sha256 cellar: :any,                 sonoma:        "2dcef7262f06a63c99f952e5fe923eb8fdd32cc11aa5f9e196e904e3840e1e19"
    sha256 cellar: :any,                 ventura:       "ff27048a31eea64796f6922568b091e9eb7bb96ea68a3b5cabe9ead8c94cd9bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0687559d1bb675a4d857ba206c47a356cb6a19c4c9b3852f422e2d1037b2a1c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73c433cd3f61aa7d2e20b29ed5d2b398f3b4cc0cdab30879a2e49e6915a55022"
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