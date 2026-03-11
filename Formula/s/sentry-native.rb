class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.13.2.tar.gz"
  sha256 "67513621fb1c64c2b225bda51701891516f13d9de8d428585b928ec8814aec9d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa62f3d1946409b732ad16b17e72a26179e2c128414149cb5e98d99da456ca51"
    sha256 cellar: :any,                 arm64_sequoia: "0404db346742bc89836ad7b6f117aa4a4cc043fe51879629287b684affeb82fb"
    sha256 cellar: :any,                 arm64_sonoma:  "c32620380e8cce7a78e12fa264bde1e03a12e3771c2b8dcb86b463d03faabe1e"
    sha256 cellar: :any,                 sonoma:        "adf112a64d0da04fb62365f7cb006534272cebe3f0f1870d93ecd29e41a86d10"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fac000682e97cc5f9cf7ab2540f2a00d6df7da69bcb2de701d1279fb863d1912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea6c8010e2cf3ef204242e0f1da57a6213d5c931479b863f7c961cea8d7de6aa"
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