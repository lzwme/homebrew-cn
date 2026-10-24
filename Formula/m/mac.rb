class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1343_SDK.zip"
  version "13.43"
  sha256 "3fd1c60f994daba536902f30b1bebc2235099c8b8a039d8b37d9d27d4827e0ca"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "26f2c17585a6149c0705df3816777b1420544e5d52997f0f164a2619a0ded711"
    sha256 cellar: :any, arm64_tahoe:       "9795fa5192dbb64f0805714d050bede9db5ab831b53527bcdba907abdc79b01f"
    sha256 cellar: :any, arm64_sequoia:     "e1c86351f69816705f8eb37233662a4014a29558ebf570b30de9f2df219c5a00"
    sha256 cellar: :any, arm64_linux:       "a1a8bc14c85eebd60b19192b95b2ce66eb6643456ff7f66413626124b7037a8a"
    sha256 cellar: :any, x86_64_linux:      "20ab7b58d629245458d075610b52da44cfaf3a637b4cdb7c99549b847a204225"
  end

  depends_on "cmake" => :build

  deny_network_access!

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