class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1161_SDK.zip"
  version "11.61"
  sha256 "0799c0a5e396b4350928b3cc1276096a04992835fecd2df979dacfc058323313"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "35ca6c815de47d09ead05fdb6637d9176af6a667a5304309874c1b10a269260c"
    sha256 cellar: :any,                 arm64_sequoia: "bb6b0edf2e0745370818e1cfd8152b5231d5d2df9fecb7ef15e06a80e8688285"
    sha256 cellar: :any,                 arm64_sonoma:  "b6a01ede68cb8d969c05efa4dd60865485573bd92723d8defb8ecd7eb1632d21"
    sha256 cellar: :any,                 sonoma:        "ce9d68c00b09ebfd190d9c7730731e5a0e22203d60e1cdff259b9097c9cb52ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f61e848797ab951bdc9b26e0f50c922fe041b9c25286f4c8f6552b811b6a0dc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad182a8090a4555456376b4516b3c21a5a30c7680cfa139c03853f183bf897a6"
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