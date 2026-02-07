class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1212_SDK.zip"
  version "12.12"
  sha256 "018916bd316a0023b54cbb9b01f0f472d0ccc0598a9f3fb397af3eaf1b770d0b"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3f4ffd8b1e427f9ad3a1d17fdda00932f1fc51ab23053bbe0671c43e081a3381"
    sha256 cellar: :any,                 arm64_sequoia: "c2bd07778761bfe446ef348d826b66aa24ace2e96adb7d56e2b62aba5445f3f3"
    sha256 cellar: :any,                 arm64_sonoma:  "c2611bd498efba921d4288a63ec53b4b9972fc543355fac5f937c39ba0401645"
    sha256 cellar: :any,                 sonoma:        "8f8a918be55bb633a21a8a820c1d406eef7365bd9ae59fc90f714eecd1c703b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "94a63250e27b1bd039f9fc205c2d6ec68a7f8e45ea282b4cb0adb9d89de1dd9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc3c57430ea21ebce14e29808712ba75468a9f960cf2b9c216b7b0fa940c2669"
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