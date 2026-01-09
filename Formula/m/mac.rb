class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1191_SDK.zip"
  version "11.91"
  sha256 "77a17f2a19342d8f165fbf627ce55f8f0d6bf82b6bc7732b002ad419d7dda75d"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "558a3935885c51b2ef1463a36ce1ea97ed182457be102ff1f5d6a89f221d670a"
    sha256 cellar: :any,                 arm64_sequoia: "1c68416d90fe1eb119ececfad551095dbcec6f2b98fab4f49afb70c90cc8a28a"
    sha256 cellar: :any,                 arm64_sonoma:  "0bc2175c50876325a45da357d25d91e2bf728aae885a2fd84b0444766fbae6b7"
    sha256 cellar: :any,                 sonoma:        "84f1a304895585cff2016dacefd17fdfdee1d100189f7463f27f6e7ddd8afd51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83a8a7dc7812b0ef7fbdf97a1c3ac17a894b527c36c4caa7b28d015b662106fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e1a60fb2db6efce1ac27071cd4c1015a891051efe474dc699fbf46cfd481a0b"
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