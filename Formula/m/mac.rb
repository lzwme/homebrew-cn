class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1138_SDK.zip"
  version "11.38"
  sha256 "50fb286ef83fe739427610b7658d5d3422d0b5b636e1aa52ae14277c635ffcad"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "0aac8a786a0e33bae9308ab49546a49ffc5979c50806c3514d763bcaba2769c6"
    sha256 cellar: :any,                 arm64_sonoma:  "e365c1a0a3e80dc2366b73ba48068cc14f5d136ac9d4f37302c2cef0a1abded0"
    sha256 cellar: :any,                 arm64_ventura: "1b6ca335ac00bb5591329047e63dd6beaeb4cea0690df5a4383823d40a985067"
    sha256 cellar: :any,                 sonoma:        "8e376fa82e5ef8e6aa88d4b1c236123d81fbaac587eea64f7786e373dc2532f7"
    sha256 cellar: :any,                 ventura:       "113ecf7c4873a4a38bd192101de97cce9edc8e9ecfc84507b26f6baa6df98420"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c1fabb909caaa80bc159a0e0985e6562b947b49ef923ea6bd8168e5db3aa36e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "477aa6176be5e143852a10fc64042ea4c9845e1cdb6bd8a2cf9ad5f7db964654"
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