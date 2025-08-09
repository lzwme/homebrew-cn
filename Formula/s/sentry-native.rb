class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.10.0.tar.gz"
  sha256 "ff7ef6549c258f144a85809a8f0d64b300b2ae7d6f18dc685b706923b861f015"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "774beb75dc9ca5d112bc836e03c033cfa00d7b74d6247c1d55007283d65d6f6c"
    sha256 cellar: :any,                 arm64_sonoma:  "86b300b07d9b9638c88115590eba0b631e7e25efbb7b3ebb10e6532bcccf7e28"
    sha256 cellar: :any,                 arm64_ventura: "5a8f54df64157a92bc66ec18da24f92c70c6939deaf83a8e452dd06bb57f4573"
    sha256 cellar: :any,                 sonoma:        "0aa089a2154c44eedc8518e5fa6f096a0e8191594062c58482fda038be7d0f1a"
    sha256 cellar: :any,                 ventura:       "9731e5fc030ee08e707cc344833b9b5f38850e312969a78764c18c43e200825f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6cc429b1515b019c74346b0e54474004553d418bc513b15a085223cb9c31a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df506195331eaf5e7dcca91f0b52ef33c5f4cdd1c0164667ff15a467987c42ac"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # No recent tagged releases, use the latest commit
  resource "breakpad" do
    url "https://github.com/getsentry/breakpad.git",
        revision: "9b606719129be728005e3c295d4c74bd1a15c0ed"
  end

  # No recent tagged releases, use the latest commit
  resource "crashpad" do
    url "https://github.com/getsentry/crashpad.git",
        revision: "e24b0f9e760e27464fe2ed30fdd7be45a27a67ad"
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