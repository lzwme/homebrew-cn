class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1313_SDK.zip"
  version "13.13"
  sha256 "5ea1917bc41b76d5977a2d952d63e17ab16b8d1e1be95a00f573379d794e6683"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "79c3cbbcf6377714ce05c73731096fdbab1d8b6f9b41e36e89461f11c5ddf831"
    sha256 cellar: :any, arm64_sequoia: "dfe08f12684aa21bd3601dca3831446a222f0cbc3e1a53a668cdd3626992d037"
    sha256 cellar: :any, arm64_sonoma:  "f89cfbb07d4e13126b5ac38cefe662a616ebb2b05133ed4782a9c157ba645847"
    sha256 cellar: :any, sonoma:        "d279c43ac85e7bd1d0ebab44c4a8a0369c31d1a917a48a44dae1631858a06cfc"
    sha256 cellar: :any, arm64_linux:   "2ecbb11813ba490a9ed2e96758d3e75d0e6dc02fb21cb476cd4784cb7224fc9d"
    sha256 cellar: :any, x86_64_linux:  "73e7711b04793b2cbdc99ad95652bcf4c62f9ea5d5e74bc548af15b539e3a0d9"
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