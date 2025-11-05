class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1180_SDK.zip"
  version "11.80"
  sha256 "d78310017e42d05188dbc4002d358f17502368dc450123d1d791eb0ba50af575"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "875b88fa28709bf7d3592d23916a7142af0ae55645d608f5e3449f33d5410280"
    sha256 cellar: :any,                 arm64_sequoia: "19fb397db4bf400b407b73c1ba408cb3c3736730fe24cbf18c3a441d1a072b13"
    sha256 cellar: :any,                 arm64_sonoma:  "38340c97b5749af7229abbdd5131cce5fc02a3a5b331aa819cf82f0818933c1c"
    sha256 cellar: :any,                 sonoma:        "e2b3c20b978f5b35f6159d739e5523ceaf170d68ea7dbfcf93e645b0db3f7738"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e4ff7424b60df8cd05043ade67e30a7ebbe2e86bb0455f4aa60a7fa46a5b459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "966c7da6a113c657870a3b78da76fbb6932da71d1fb4c7631c668920dc65028a"
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