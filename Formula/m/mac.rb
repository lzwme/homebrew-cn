class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1295_SDK.zip"
  version "12.95"
  sha256 "dfed316cb4aeecfdbc2d28d32a0dbe54785cc737982a97d3fcf85849b343188b"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b4ba86071a0b69ba927318bcc662a9c99da0257f4eed0bcd557c6d7109ba285"
    sha256 cellar: :any,                 arm64_sequoia: "eccb122ee49d7639e213c2980dbffc04b527e82dbaacefcaf797eec996a21d2b"
    sha256 cellar: :any,                 arm64_sonoma:  "958e64caa5b2e6171ee320a8c281cefb86055f94d200edc1adeed9fe11e3fc4a"
    sha256 cellar: :any,                 sonoma:        "dfc88061c88a92500a2b0783df37a47029f481b92f7a3677dc0a30e3c469493d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0afd7b9bea5b92d1a75c9ab714260a9735baf77bc652ad9da736be6f986454ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4483aee70c32de5634541d01f2aba82316cf441a7f35ed42473001b656cab78f"
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