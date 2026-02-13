class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.12.7.tar.gz"
  sha256 "ce69d233fa2e338611b880a54492df06a3049239d9dc65941abd290d22b36a58"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0a986d50583e7bcf844232e411ae4494eed27e9df9d73a5ca88b3d0e8b038d41"
    sha256 cellar: :any,                 arm64_sequoia: "78d275f767d229b130b78e9a3b9c055208bf917ce6d79c02c1f73e4768fcd3f8"
    sha256 cellar: :any,                 arm64_sonoma:  "db4180cc2a41543ad7a98f1609c159a611634c2a1275a7aed973791473488a30"
    sha256 cellar: :any,                 sonoma:        "97df774e40e87e4d602b5307d4f193cf59909281b7cd5ccfeac516d70174239c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d6dafda882fe24a736f7d32c0ff1485e5b384a32b776a79622991a480b9e7c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f41f32a220b172a2953ad248a45a3d3987adab942cc4560b08f8dd56cf17908"
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