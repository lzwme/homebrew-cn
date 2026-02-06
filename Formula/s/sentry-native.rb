class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.12.6.tar.gz"
  sha256 "9d543e69fb76860624ec45ac6a20271163c6f4d6dba6fe4d1492bfb247b268f0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8ded1a1b281809df7c721dfab62b16c8e57cd9e9b7f7baf6a68fd688d8bae202"
    sha256 cellar: :any,                 arm64_sequoia: "e9f90ea7c613edec038a9a3eb4636eb5360850a6dc7ef3b684087247429fa626"
    sha256 cellar: :any,                 arm64_sonoma:  "d673ddf5770ce675ef6f5cf0736f82ed50796cfeedd8f39f3b2afe8719808db6"
    sha256 cellar: :any,                 sonoma:        "6a1fa7781792f72bb5ecbbbc415d59699af72e6ed0ae7bcec2e5bfefc6c6f61b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05b9db9038d260c32198a1cf2aacb1a1b38b984d02eddca27c9b56c3c7fadef9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "064ba4f23b5774b4a7e6181e4cca0b0adc50ed32bef17d874faaadc32f57ba1b"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "47d70322c848012ed801e36841767d7ffb79412d"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad.git",
        revision: "eb5fa6e8576e79113b21296bd6af7e2a542839db"
  end

  # No recent tagged releases, use the latest commit
  resource "libunwindstack-ndk" do
    url "https://github.com/getsentry/libunwindstack-ndk.git",
        revision: "284202fb1e42dbeba6598e26ced2e1ec404eecd1"
  end

  resource "third-party/lss" do
    url "https://chromium.googlesource.com/linux-syscall-support.git",
        tag:      "v2024.02.01",
        revision: "ed31caa60f20a4f6569883b2d752ef7522de51e0"
  end

  def install
    resources.each { |r| r.stage buildpath/"external"/r.name }
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <sentry.h>
      int main() {
        sentry_options_t *options = sentry_options_new();
        sentry_options_set_dsn(options, "https://ABC.ingest.us.sentry.io/123");
        sentry_init(options);
        sentry_close();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{HOMEBREW_PREFIX}/include", "-L#{HOMEBREW_PREFIX}/lib", "-lsentry", "-o", "test"
    system "./test"
  end
end