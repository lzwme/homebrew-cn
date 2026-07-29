class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.16.0.tar.gz"
  sha256 "eda2589bf3d76ef65f3a85c7ef4ee74cee92fd7c5cd018a323321167176589d8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d6c9c9e84ca9e7b32324d8c1b00895b8b27841dadab3e62eaaa146049e9cef46"
    sha256 cellar: :any, arm64_sequoia: "45c098375e73388d4bdc16b4fb43c40c69c852a19707eaf2674561f887444fb0"
    sha256 cellar: :any, arm64_sonoma:  "d981169b79e3c87185a94d62bdde5909e0e755e398229ea7eb467f5ee290d4eb"
    sha256 cellar: :any, sonoma:        "ef92133f9c85b7d3006c267330c3f87e1c2d414d727efff79445b0c111c0fb66"
    sha256 cellar: :any, arm64_linux:   "7914d7734fcf71c7e4a3c0762314d7e2a014e10176e140b8fb723f7957c8e171"
    sha256 cellar: :any, x86_64_linux:  "29d4940d193a86111ea708538626260a3eb8e38bf244bd34f1b2cfa647812ef4"
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