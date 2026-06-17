class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1305_SDK.zip"
  version "13.05"
  sha256 "3be9f2e07344cdfb362996d439ece06f822cf8fd3551914081d29c3af00f9638"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3df8441b9f6dcddf08fbb5ff86f0f4132ae1bb2ff870a4b44a575ea0808d28d2"
    sha256 cellar: :any, arm64_sequoia: "9037b7380c86dfde05a92637872c629dc649ccd1f3e41e329de01cffd9799638"
    sha256 cellar: :any, arm64_sonoma:  "bf6721be2394214ce6defa251e415ae165695a5b17a582c225283d8c8ffda5b4"
    sha256 cellar: :any, sonoma:        "d10dd8d211a272a826b2724a3d575275d0407a694b4fb5aafee6154c3aa151ce"
    sha256 cellar: :any, arm64_linux:   "f612a46db0159012ac613355a9ace01e34abe9eeb8f132e2aa88a357e7ba5a22"
    sha256 cellar: :any, x86_64_linux:  "08b0d909936b1c3150ae1344b279930d292498ec8b20b8938a49595b5d788f2e"
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