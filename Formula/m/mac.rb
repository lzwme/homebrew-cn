class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1189_SDK.zip"
  version "11.89"
  sha256 "e641cf51139ede6e2b3055dedc24e79e43443339dee0d8ef8b0b7aa50ae22008"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "612df918bd8e2e7ecc60487516f88d2660af4364e9a5cc2b72ae53d8f33da1c0"
    sha256 cellar: :any,                 arm64_sequoia: "bb8e4b47ec47a28f9f9a04f119ac499d9bd9d3a7e0cc8adccf4beb4b64bce932"
    sha256 cellar: :any,                 arm64_sonoma:  "6673c8a802dccc0b7645aa449d19a809c3322d9dc24dbfc7a3d7b7489bd66e78"
    sha256 cellar: :any,                 sonoma:        "b816edc1c67c1c1e84cb69eca1dece35d5de2d7c038ab4f1c0a1c30ed0859d14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ffe7cb34ee590be33e92c73ccd237c5ef9c804442356020804def1b9a26afd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ff0c55d84b3a606f3e168e33e93665ab48fe385851e611a64d056b61b217a5f"
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