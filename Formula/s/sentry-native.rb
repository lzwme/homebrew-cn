class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.12.4.tar.gz"
  sha256 "221dafc8187dd5e83282eac87fa91aeb110f6036b201bec9296f5ddb94b59031"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "869eaa9732a423c5ec2b766f24ed83733e77a50d88b04846d9e2f5bb1ca6e665"
    sha256 cellar: :any,                 arm64_sequoia: "36146a0e775469bd87e036a82faf5a7b7a637e7596d0a1afb99a5789976a2531"
    sha256 cellar: :any,                 arm64_sonoma:  "b52b03db78548159d444b0e2d4efed26a10075e1ee4bc6bf68b390a71d884ab4"
    sha256 cellar: :any,                 sonoma:        "d2af67266eacbe48a49741490a3e746f3068a48a00e44a6a9556f078f8382901"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be04c8a89919ce15eb952bbc40ff2092260c8b02f6ab7fb21758c8087d51a58c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1574474622fe621ae3080458b44560a72c75aa52c7baed1cc95905f669a885f"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "47d70322c848012ed801e36841767d7ffb79412d"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad.git",
        revision: "63ef3357657ca856d5ff1dae9fee8dc16a425811"
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