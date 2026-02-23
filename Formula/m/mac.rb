class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1235_SDK.zip"
  version "12.35"
  sha256 "56c788a2ecd08d87b3b65d870ca64c6cf07d42436db7c233de4fdd217674421a"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "502dc43bb879fbce4ad49e4410557794232e9eafe62e0d723c87c282ce836b7f"
    sha256 cellar: :any,                 arm64_sequoia: "58f1e86dfed5e7015464d2bfb11deca1e64bee033c0464a6cfe8e8aa3bbe7161"
    sha256 cellar: :any,                 arm64_sonoma:  "835409a14a802d7bb5c236c739ed79a5e73271a6784765229624b47774125f8d"
    sha256 cellar: :any,                 sonoma:        "5f084ba07ac0fefb38067fff0f455386ac06950e740a11016323b5c14348359e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff8a1a6a92f1a3950eb9984e6084a581978acd18be1d6870f251df1bffed374d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c11da6cf13090942e770be8cd66f5db52f41013c4fee5b9a8b773ff7f68a41c1"
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