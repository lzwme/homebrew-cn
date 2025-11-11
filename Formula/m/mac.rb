class Mac < Formula
  desc "Monkey's Audio lossless codec"
  homepage "https://www.monkeysaudio.com"
  url "https://monkeysaudio.com/files/MAC_1182_SDK.zip"
  version "11.82"
  sha256 "c55a586c6f180c82ff8c9955117be15fd1e1f785d7175c8153cb97f8609fb157"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.monkeysaudio.com/versionhistory.html"
    regex(%r{<div\s+class="release">Version\s+(.*)\s+\(.*\)</div>}i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "215d2f364946c520bfdcef6592b5af48b341ff2cfd67db9d55d17edea5d37db5"
    sha256 cellar: :any,                 arm64_sequoia: "42f9a60a8aee685ce5785e07a010b7ba09df3452dd3f23e5289556e0e566d2e9"
    sha256 cellar: :any,                 arm64_sonoma:  "c83e4fdec5040824a5625b9da37c3c0ccc5c19e0f203dca06aeb7e5ce7ad1bcc"
    sha256 cellar: :any,                 sonoma:        "30980f338424a09d79697505a21ceea5bb6cc0de710f8f5e8b05fefa06899304"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2be292304ef74e78f332541094674b44e0eaf60b40372e9168e709492b57e728"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1fe7b58e57fc35cc78f6ab5ffe6e1057bf04e347026b24ac05875d59c65f430"
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