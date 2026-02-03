class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.12.5.tar.gz"
  sha256 "c72123208a4b72a81aa545d65a39561beadbe50499bf798310bb5010316d76e2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d614143c40ca50395699d85c9a5901b2aa962abeda4a41fd2a1636b1808f1a5"
    sha256 cellar: :any,                 arm64_sequoia: "52f194cc6bc9294845dca0e99ec8840c711503818a0361c18d1657ff4f584410"
    sha256 cellar: :any,                 arm64_sonoma:  "0f8de137b0cf410729ec10637cb561bd1c32021e3380f4039337048c6a8b1048"
    sha256 cellar: :any,                 sonoma:        "a83370e9283340346af621875ad91c065bb035eb7d0ef42da420cf11a3a49314"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1def6f958b6b455ede89594dde474378a6fc57735c01c2fb899d8b307f1abac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0e654d6f23b3534a8d2065595b993db6d9f19d4aad00a1ee0ef93458296b2dda"
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