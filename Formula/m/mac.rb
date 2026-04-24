class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1270_SDK.zip"
  version "12.70"
  sha256 "0ec7941c497461f758685bf18ba8c758d20515085bc59c4e26c45c778a67d2d3"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b54bed301ad07a5267701d45cf4efbe0f98fce194234e2e0bbe4934c2d6c9f6"
    sha256 cellar: :any,                 arm64_sequoia: "1c96f140ce4bee019ca63a4916f858f37096ec4f0a04b75d430e976ecaa6fcc6"
    sha256 cellar: :any,                 arm64_sonoma:  "2cbbb08aa5e21ac775096d97a1831b265cdf9090bd615173ee662ea29c9ecb12"
    sha256 cellar: :any,                 sonoma:        "5e43de734656f10bc6c89809b43995fd4be0c0f31a1ee35d00829bb3140d820d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc67ad0400c4bba7b21c8fa85f6f136d10c32d01f534524ce6cb9ad0596b9ea8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3936bddab45dd6969788d46e78fc0fdb53d5edbd116ee8a198c867bc34320556"
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