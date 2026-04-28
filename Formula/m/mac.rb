class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1273_SDK.zip"
  version "12.73"
  sha256 "a439f68d425753e0ccec2c3285570bdce836660496f8986a699cb6ea717a3c18"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d072668c99d1913ade65eae38315f9a94fc6d83976c4689c178fb4a959b6b12c"
    sha256 cellar: :any,                 arm64_sequoia: "22ad5afb1edc7163caf1ac34ad93cc29645f321f1923a4135c281b132da715fa"
    sha256 cellar: :any,                 arm64_sonoma:  "f17ed7be2e758c3b03c621d7d75b730d2cca060a52d4060d645bb46419beabef"
    sha256 cellar: :any,                 sonoma:        "685ea76ab65fc88e29402ad49c8f84e7a8aff08c020b0d9bba4ccf5d7d58947b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c96aa5c9a5ef9d69780c491a67a905d6eecba9eec1aeaaa835d78b0efeb5289"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c159ab3e913df250910b2e03cdb7857eaea7ee031a0377e888af45107761518"
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