class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/releases/download/0.17.0/sentry-native.zip"
  sha256 "f631809b43fa8bc6aee2c97f955073971677f2f2d6cc239587a8c20ff427ef55"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "12ef5a4aca03b6d929f087453340cbbc543a66a9ef61deb889837ef9b75b8096"
    sha256 cellar: :any, arm64_tahoe:       "ac3875c352d2b8e15b628b5c6152719814c528fd0a19b2e19892bb4ab6cbdaff"
    sha256 cellar: :any, arm64_sequoia:     "ed2ee3a95d2d5a38d6538ee975388124d9fee2be5da13e22c8976a104976cf98"
    sha256 cellar: :any, arm64_linux:       "8a7014aec45383c26d80afc97634e7d8ac881294447735769ed2e0cbe7107fea"
    sha256 cellar: :any, x86_64_linux:      "25606d26d020682b2df69b2e1d3e26a3b1d7f39a26e0324addab853dac8ec8c6"
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