class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1111_SDK.zip"
  version "11.11"
  sha256 "d477452c31dfd1be567c910a1f06e210bf5f6197ba8f20f879cdd0c8c3d35cf3"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "41e91f7dcc53ea35a5c5ae78dd08431efb9c2d7de35f62376842aff5bd51c9d9"
    sha256 cellar: :any,                 arm64_sonoma:  "103c49813e23de001f3807dcfb04729b01060360751290ae909b4b5a3df64b48"
    sha256 cellar: :any,                 arm64_ventura: "c6eb5081d170aac3294b23de63a4e6885bc757641a89a135548ad6ade489a4fc"
    sha256 cellar: :any,                 sonoma:        "b50f6017a179baec04b42fd90b413097eda52dd4b6d7d6b3181ac92f776e5c92"
    sha256 cellar: :any,                 ventura:       "41bbd7396c83d11c5e425c880b2f9c910c5d9f9d73f0c94c816410cb9a9017ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b58597d7910a504fb6d4c3040b3635275660f196a8f97b16b75be9e24ae3e3a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b85302c79cc549434857134f091874a5f73d912d6140f45de79bc0b614ef83ff"
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