class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/releases/download/0.17.2/sentry-native.zip"
  sha256 "00b4294299cc9d663fd5445dad3f7ba9c96087a7b00884bccd270edd96fb9f6e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "07a2fdcab8cbb3a4f4421ed7a02c8d889c753ca8656a92c8353c65f2301b01a9"
    sha256 cellar: :any, arm64_tahoe:       "9e1ce093af30609bd05810b0909d902027a27f1f484a2d769af8b14839905a0b"
    sha256 cellar: :any, arm64_sequoia:     "ea2fffd220b43100183e0b818e8de3974a5a8df0bccdae95a9d73beada5f2b79"
    sha256 cellar: :any, arm64_linux:       "767f1edd8aa31b4e1bbae3fde7dc7fa2915511eabe4575f9939d4292ba1917d8"
    sha256 cellar: :any, x86_64_linux:      "49dd2ec5e92e8d709b0f34dceef521f98137141cf445003baa0decb578b71ec8"
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