class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1152_SDK.zip"
  version "11.52"
  sha256 "664411f97f4674ef51ada577c90b6ffa4093b1babb6e82803f145e48aafd10ac"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "03c5e140d13524cdd0094c9dd6bf2fb374bd5c881ee42865fff0bb662ba5272e"
    sha256 cellar: :any,                 arm64_sequoia: "a192bf98b3a5ffa055bb996df65eeb4aeb76e005940ec6e5644814a1c51a6d2d"
    sha256 cellar: :any,                 arm64_sonoma:  "78d1a91d557deb127eca2232f318c7fba03e4d627123644cdb955eceaefcb8dd"
    sha256 cellar: :any,                 sonoma:        "db9b18b4a8f4edb253ac7489011bb817c43f512a742c4518cf57425eefc8b341"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52d9c9a3c735ea7450f9fd0cbbc3dff140136848cd84e64727729fa5554fc097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96176e7ac31057d2517c456d79bfd9772cf720b01a0b73ed083bd10db20fe4b6"
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