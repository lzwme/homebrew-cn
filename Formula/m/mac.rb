class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1114_SDK.zip"
  version "11.14"
  sha256 "ae929340951b3458b92da0520f567967405eac5b2304685617b84588e1f5d179"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "292166fa67324332787ecdf77d54da2ec61901a076a99f2e9864d16751c335f0"
    sha256 cellar: :any,                 arm64_sonoma:  "fd5617946096532490a2a843a16ccd646f7380d9435f7eaa35643200a0befe2e"
    sha256 cellar: :any,                 arm64_ventura: "8c155a32986f86a4a672d93f4f9e413150474e15b422e4f5e2b46f16d5506a8f"
    sha256 cellar: :any,                 sonoma:        "e44d1d6a08a82225eb1ffb53bc995a375414df908d34a584efd35d71de45a511"
    sha256 cellar: :any,                 ventura:       "47de4b1d9c8999bb4341bb7f6ceb73bdb1db02135342bf41148f91fce1d582e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60e1af874d02670fe83de7ad7c1b8f3b4110dbf934a2f560dab45705f8c1c7af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "456037233d18067c6f3d0ad340f5e1e5615f3b09fdd38c47958e39cc5f67f4c4"
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