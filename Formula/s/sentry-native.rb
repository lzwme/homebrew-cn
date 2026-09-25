class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/releases/download/0.17.1/sentry-native.zip"
  sha256 "e510b714ac0fb5c24b08011e07c5b13fa01c9bd0f40708356e4af022aa20c5a1"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "bf8b4e526d94c9e919faf89c5930b173b7c1bab6ebbc16ac1c5a1f968bec6911"
    sha256 cellar: :any, arm64_tahoe:       "da953a71816e8f956017a783464af848ed69c3177b0c0a14f882a39122525a0b"
    sha256 cellar: :any, arm64_sequoia:     "4a25dda820bb1306193253242500f0674718294da2322c441a565272fd3af6a9"
    sha256 cellar: :any, arm64_linux:       "3586ca7f2652b3f3372d442d693eff7454f29d006f36401070cfe5ef0b3021b3"
    sha256 cellar: :any, x86_64_linux:      "5cc2888f072e6b1309c6929865a7a19115f0f412b7f7c7611abf42c3a9e2a3ae"
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