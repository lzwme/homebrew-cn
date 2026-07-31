class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.16.1.tar.gz"
  sha256 "b3ddcef97025a4d4260d163578a790a87bb92323988a621e6eae620b38e1b81a"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f72c9d99eb723141bf691331157d59b1cb1db5de4c8e1646941a2ff881f6299d"
    sha256 cellar: :any, arm64_sequoia: "06319a437d3763691830e27b3b1b437f60ada75f56c2c89bf547e9c5acb3e47f"
    sha256 cellar: :any, arm64_sonoma:  "3b701da5a47925bb44872ef47b557849eab9050fd6bfbae8fb0e92e60bc6fde5"
    sha256 cellar: :any, sonoma:        "1b5453b9acc0be6165b01baec655b7c20349adf74a061a0ebc945dd7bdd01df3"
    sha256 cellar: :any, arm64_linux:   "703329fc0aa142101bb1d993f2ce60030395ca2d0b1cc3b3306d1ee97528f477"
    sha256 cellar: :any, x86_64_linux:  "a1bb9bb4c75d724662cf8a31ef69c74d09c591b4a6595e35b4b53868a8d6bf4e"
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
    url "https://ghfast.top/https://github.com/getsentry/crashpad/archive/aae505d3daf73e8a48136ccc7398663f16096712.tar.gz"
    sha256 "cfc713e322f1ec7c9d963a9e25b176937464a39a7e95826ffe588cd0bb9bad62"
  end

  resource "crashpad/third_party/mini_chromium/mini_chromium" do
    url "https://ghfast.top/https://github.com/getsentry/mini_chromium/archive/bcc80d6edf8b49d9bbe7a06fff308c222287b112.tar.gz"
    sha256 "009adf4cce8d3aba9e8d5ecd802cdc60eb87d271a3fb5f356c453b4a4122b219"
  end

  resource "crashpad/third_party/lss/lss" do
    url "https://chromium.googlesource.com/linux-syscall-support.git",
        revision: "9719c1e1e676814c456b55f5f070eabad6709d31"
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