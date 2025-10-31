class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.12.0.tar.gz"
  sha256 "77c27dbe98cf5876743e53e8c88677eedeadba09c2e199316e3e1fd45c2c4f70"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aff922d2a5b33fcf69b81fecad8e4510353992e0ea004d7a161f59747578986e"
    sha256 cellar: :any,                 arm64_sequoia: "b9f523e6649346bfca332d41d8f9680131d87e265dfde2b9bf995cdd06456801"
    sha256 cellar: :any,                 arm64_sonoma:  "e1784ce39344b02c8f335f3100f5e8af8704a62bd57dcd57685e99ae678e6339"
    sha256 cellar: :any,                 sonoma:        "859ede0c2f7cd6a97ea544927b277805c0503c3d66055133acc6d1247c220958"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56adb824fcafdef7209b61bb6803d7d67faaae53b35619c4a0fea2a100bf69f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7fd93fcc222a1476b399b03facc66c70649c3c70432c8aa7334e78f63e4e477"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "25b6b727af49fa383161e7dba4a82ab0661b69b8"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad.git",
        revision: "d8990d2f686b8827a21532748c6c42add21c21ea"
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