class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/releases/download/0.17.3/sentry-native.zip"
  sha256 "930039d20b8f7d5520c8cb1d9911d63ce8a9e0635b56ae08256936d1f45b66ac"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "28a0a3e6df01800f2c16c898b8a770fed26755b04841431eba38f1ca825c630c"
    sha256 cellar: :any, arm64_tahoe:       "b54dad0ef0d1b60724465dfc0adc558dad466d2ad92e4f0abc5bc1b8c729750b"
    sha256 cellar: :any, arm64_sequoia:     "1d1691b02985b553509f9cc67de20bd156fc96363d5392876d4f56db803f732b"
    sha256 cellar: :any, arm64_linux:       "d7c40e041b0818642a44ee2c5f4a8687ae5ec57346ffb2ce4ce01459147b8bc5"
    sha256 cellar: :any, x86_64_linux:      "042a326277318772b932206e0d0cb3539267278597aa36de05a4cc2b3d0762e7"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  def install
    rm_r("vendor/libunwind")

    args = %w[
      -DSENTRY_BUILD_EXAMPLES=OFF
      -DSENTRY_BUILD_TESTS=OFF
    ]
    args << "-DSENTRY_LIBUNWIND_SYSTEM=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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