class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1324_SDK.zip"
  version "13.24"
  sha256 "46c799e79a43e004d24c135ae72939056bababbc0487ecbaeca8efaeafd2a9b6"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "696fe7a28f8978ae3a7c3e0b373e25e8f43a94253c58e365cdb285c27663a494"
    sha256 cellar: :any, arm64_sequoia: "e410324d9c013572140b721212ded46918375026a06abc2123f0a45f3c441eb2"
    sha256 cellar: :any, arm64_sonoma:  "5873c4e27a28a81ed0a98db1177e281a31ea532064d957c787da093da6a7019e"
    sha256 cellar: :any, sonoma:        "b4bad5d8000098460b7f81456cefbb1dd1a0890dda69adf1462f797205a93b24"
    sha256 cellar: :any, arm64_linux:   "b0624457f0b6312e3bb65070ebbdbd2134d9516dd9822c8eaaacd1c5381a31ee"
    sha256 cellar: :any, x86_64_linux:  "eadfbe1990b74cd30fada0e0ce5d3f19c4b3185683984154b4f085a6005a9591"
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