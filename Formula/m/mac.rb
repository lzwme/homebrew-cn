class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1236_SDK.zip"
  version "12.36"
  sha256 "6cccb47cbc793289c1847fe98a4669ba651b5799835a754e5b00fe65ae43328e"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f7bd3e0c8792995300e709e6d415f5652ee279f096489a903bee52967d7fbae0"
    sha256 cellar: :any,                 arm64_sequoia: "2a02f334286e30896281a532b20356db16d0431230b981a939a814e7389c1a90"
    sha256 cellar: :any,                 arm64_sonoma:  "91b6281f262967ff63f2d94defe5446061e320a65944ab071ce714886eeb48ce"
    sha256 cellar: :any,                 sonoma:        "661cad484aba798cd2d87e99f8dc31acb1365173b06ea214bff386e9c1c5dd8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acd6619ee0d755b8af7372dafd9b9429a6d4cd76d74060d0c9686353aeaf4837"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51149de7faa0a8d2cd981d4a366736270670682342086e99f8a597e30e19ef5f"
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