class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1211_SDK.zip"
  version "12.11"
  sha256 "3dc9603706edc74641c5c6286298d01c831450f6150bc45f234866c8df20e164"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8b8a5377ba66b8fd3428c248549b0aab8e4ad9b83b326d92c28074f6981d793"
    sha256 cellar: :any,                 arm64_sequoia: "3ce0dfbb10b97966cae8509150e499c43c9a16df51a0f21d9585a68b07f001b1"
    sha256 cellar: :any,                 arm64_sonoma:  "f9cf06b3b6c3a8b3a1e5bc534e32e3804b7affa7cf156f2d0c62bd921bbb60f0"
    sha256 cellar: :any,                 sonoma:        "682472ce55e76956a9837b2d887b0fb6faf5fcaee0a080860430f9ed3e8c04ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb298c108871c3bd8e0aefd73220f281dde8f4ba3bc3e359ca28cea8ebc46c0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a84ddd75231dac5721dcc0ef62e9e62433dd79e96ee5bac3612e4518549559fa"
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