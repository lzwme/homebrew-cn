class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.13.0.tar.gz"
  sha256 "36fc34926474245edd1f8dfd44012ce48819eac7e70762fba6d3dee0e6e7794b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38c22f570f3a9b463ee156791074fc75772e920a8eaa6ec5d2cf7caf7c3685d8"
    sha256 cellar: :any,                 arm64_sequoia: "b880324a29854a1ce7179134a2def8d5026956401742b0f07f44cf79c58edaa3"
    sha256 cellar: :any,                 arm64_sonoma:  "091fb85ada3fca3b4f1ee2297d696bcf7c5353c5e70748aaa48fcc7053a062c8"
    sha256 cellar: :any,                 sonoma:        "e3021236c53a8af9db5d0bebfc158ef14ed1bb3ec6cf7013d6fbe1265ea1515d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6356d2bb304496b7b1cf3f9ebcc91ca3e7f09448634e89e486b07ab833f807cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47b3c63e88e2bff4838a6b0f62e02ac5ea22ae463b341aee5880bde5ba8fcad9"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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