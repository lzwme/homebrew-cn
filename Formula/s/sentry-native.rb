class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.15.0.tar.gz"
  sha256 "c4a029f90f65dda5272c3be8e7e041d9e4320e0b1da92eaead79f2a24c5e600c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e7931e5772f5aab7aeea411000bb41414194c2d76076e4a81b53b79e2a09a145"
    sha256 cellar: :any, arm64_sequoia: "386764f70a507f9bbd06ec914ce2cb5842325c1f5eb65b1cfc75f29ac0712db4"
    sha256 cellar: :any, arm64_sonoma:  "8fa07140a1c46f482a6891fc2c5302e9a4c4ed1db40775bddc7f8f1903034c09"
    sha256 cellar: :any, sonoma:        "7c7d964bc57e676009ff2299d8a38d6adb77a1a5a74194bcbbd876764509380a"
    sha256 cellar: :any, arm64_linux:   "99b78fb5225cf05684a6d293d5aba480297d037dc0242dfac2c2478e6268109e"
    sha256 cellar: :any, x86_64_linux:  "24f51918c183e69673ed1da821791b382a55c7cc83afa173795f94e8a40a03fd"
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
    url "https://ghfast.top/https://github.com/getsentry/crashpad/archive/ff141a8c0cc852f9c3d42e13bd9ada551351bc21.tar.gz"
    sha256 "007b7d57e8dbb8665ddc524350f1c50ea646dcdc55b6278bb6a1a18e206754db"
  end

  resource "crashpad/third_party/mini_chromium/mini_chromium" do
    url "https://ghfast.top/https://github.com/getsentry/mini_chromium/archive/64339ac9468a8c3af236ca9186b42a33354455b9.tar.gz"
    sha256 "f3f5b619705ce0aa139f13d654950ba4fdc5a4616dda74efec91e2f5e04b378e"
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