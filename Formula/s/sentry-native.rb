class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/releases/download/0.16.7/sentry-native.zip"
  sha256 "4cf8d4de2d560a39c36ce27f934f9bf305977a392f6221a79caf83c87663fd9c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4f1d57b0a4acf9673a16d1757c6cba6506145816f8ccff74da532e0710083958"
    sha256 cellar: :any, arm64_tahoe:       "ac68343ad6f163a57445f4e667c5dcf1c34fb35127bc0898eb7839461953b12d"
    sha256 cellar: :any, arm64_sequoia:     "b4be126221785be7ad8cb9f2aa11ead6d6d27a4530bc1075eda78ff9dd256925"
    sha256 cellar: :any, arm64_linux:       "cae985547d082adc93a4dfaf6efed664519e5f67797fb1d823d3e90eac4bfbb4"
    sha256 cellar: :any, x86_64_linux:      "bb2ade616d9d57de0429821d9b7fcb976706877e50407116509af362cddf74a5"
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