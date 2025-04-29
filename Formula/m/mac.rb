class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1109_SDK.zip"
  version "11.09"
  sha256 "b903684291b6242bc337f4693aaeed835e8f151659d272d45fe3ae7e401ebc89"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f03f4ff36c3e6c0e6d652d3938169e0e194215a77662ae8790935a5591e82f9e"
    sha256 cellar: :any,                 arm64_sonoma:  "92617e01bf13191206724a468bb5e71a17055ee2950fac7a5070ec3759782e1e"
    sha256 cellar: :any,                 arm64_ventura: "46dbf56de09467de6d22113f192b348b70ca1ec75008ef23d4e216ffd652c7b9"
    sha256 cellar: :any,                 sonoma:        "9985dec947a960e2375c8b8cc127b9e7320900b20ed15e31817dc757d4064736"
    sha256 cellar: :any,                 ventura:       "1b9d515e4b9a3c74b57cd33952a86c093db32b90b0dc05b779060289b4e49405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8472e0b8536d034c0152a49bfeb52bd503cc194e5dccf249f75298f6544b960e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70aadf18e6f43751d5c46079a471b90c8f3f7533676c18f48beeb7db81cd11a3"
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