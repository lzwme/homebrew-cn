class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1325_SDK.zip"
  version "13.25"
  sha256 "0c4c82e60f42fee8deaf4facc28a56a9f84b7afcc5631a7d2c581f8e8ea33cb4"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "67006f933c326ba0dfc00a93b7154ef1e816a873d0061338aa638eddd4c18586"
    sha256 cellar: :any, arm64_sequoia: "f31e034d849cab29e628679d43fcb86675ec08569f94bf5091c8f035c0a9112a"
    sha256 cellar: :any, arm64_sonoma:  "add5eab4598139027a8daae59b67af46c4b478ffb3d2f9ccad8e03d1ec0014f0"
    sha256 cellar: :any, sonoma:        "3a19431237273e80af95c2aed27ef7379791826f5ef516f5b2bf78256a86c7f8"
    sha256 cellar: :any, arm64_linux:   "a0c9b69b92e98d8e0a84665ebe3d3a8150857c41d785a48f6ca0393b47659ece"
    sha256 cellar: :any, x86_64_linux:  "4e661f18f3a9ba01b12913c9d89c7cd77d448c27f66c3911c02182ab8070a1de"
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