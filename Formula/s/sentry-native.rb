class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.16.4.tar.gz"
  sha256 "3d90eb840a00a11ff7a6e2be756ce8d6df112b1b7d6b3a19a272b65597d00530"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "12058163a49b7eafeeda22cc751a265ad228e3bfc0c3b5368616d203c764e9c2"
    sha256 cellar: :any, arm64_sequoia: "04434e870205e25067ef2d7f13f3ecc342925130733fc7c63b6235f11d28395d"
    sha256 cellar: :any, arm64_sonoma:  "a0bd580d9e2948d27161a001663892d9263c09ff34359b60f29ebfe1a42c6cc2"
    sha256 cellar: :any, sonoma:        "8d7b69761d2674e91de4689d7978388741d7590ce769f47ca8ffa1fb09b3628b"
    sha256 cellar: :any, arm64_linux:   "f487a079f7e62c78080ac95196e138325e973313ac3988f21db0f1e5e0284721"
    sha256 cellar: :any, x86_64_linux:  "2ada07224344c19b9ea56c38f00a1e902359a6873bddec0575ee106efa65cf21"
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