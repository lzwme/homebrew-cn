class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.11.2.tar.gz"
  sha256 "10411e20406826bc4337f8e99225707450891629a835427891248e8a11d375f4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1b15d233441dc6f393873da252b772640108e4f1e4e236bd5ec5e3c1cae316b"
    sha256 cellar: :any,                 arm64_sequoia: "16d3bf321d4f4e5859ba9aafa369b96ea1073d6565362835a1e83055eed7534d"
    sha256 cellar: :any,                 arm64_sonoma:  "7e892822daaf41b1489dbfdedf61829b8044c25c15509d6bd3fc52f9c926582e"
    sha256 cellar: :any,                 sonoma:        "77dd619d327b397b7f6862768052ba8055d8bfa8ee32cf4d9166c4711915cf24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d912b063e675d4fea37189c6ddeab25f3e28bc0375f387e54aca1e08a498d5fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "527c5f0a748b11f80f22a896376155643c283a0921b89951822f798e9e3511e7"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "9b606719129be728005e3c295d4c74bd1a15c0ed"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad.git",
        revision: "79a91fe62324c9c17c8ec1b8508778228ba955a7"
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