class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1122_SDK.zip"
  version "11.22"
  sha256 "32dbfa43f5fb3004a3aa8ee4391957056e847fbea641e6802ee431a471b0cfee"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "62bcbbd67b6a5f7dfb2b04dad826fb2020e86ff3e146b55876199190cd253f11"
    sha256 cellar: :any,                 arm64_sonoma:  "920a041bdb4853426b9ff08dc4dedb6e060fcbd92752b2cc6c7c0bf513c1cf92"
    sha256 cellar: :any,                 arm64_ventura: "bee132490b8137838ec6dcd5430f1d4798cf0d10a427ca8e8db53740f3a2ffa5"
    sha256 cellar: :any,                 sonoma:        "882dd50659f2a256a1824d17695a4765f6905e35c00552a36714867a94f45a8c"
    sha256 cellar: :any,                 ventura:       "36827abf2e2656a18d84260bf6cd1d306e6d9c35da19f4184bd1c2433c8986f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf3322dc58de8c926eb90f795305d7797978c8adae0c0628be534fb4e5ba3f4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "396ca5372f716cccf26905698691b759ee35ee555ddd8c791ca3c038cf0ec0b2"
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