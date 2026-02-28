class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.13.1.tar.gz"
  sha256 "bd709a7ac7554f282b9370d669aa457f621631ee86620b11bca79fbb7cb36dec"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ede7bba1e037ab3085a13f2fc41503a28dcb4ec5f6f49d6c2f002f477552adec"
    sha256 cellar: :any,                 arm64_sequoia: "5cfd4080a499d10fa7ea68cfbc41c58174f71dcbbb5bd34b98edaa577870a724"
    sha256 cellar: :any,                 arm64_sonoma:  "946503f904f21ff35d67f8792ceb4ebe49502d22acf43837b45f1d79ae989192"
    sha256 cellar: :any,                 sonoma:        "d9fd7d3c4e796d0dec25d2c779559d147c95724e04477544c842d20c64534660"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "657db7b8aec49041f6b523b3a6e7bab07db952e5bbd85f72d91d83af19ef6b56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bc9c8f67feb595a08b7b3e98634b64358457a320fce242d2f6b61676024bd96"
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