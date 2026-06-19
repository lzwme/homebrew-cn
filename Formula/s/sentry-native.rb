class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https://docs.sentry.io/platforms/native/"
  url "https://ghfast.top/https://github.com/getsentry/sentry-native/archive/refs/tags/0.15.1.tar.gz"
  sha256 "522fb3477d07985c6a11a08b62e64f60827a23d3b533bb738c797a5920ce5375"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f4eea5932ca5a72da50f6cc34d0f529f88e5dfb4ee9d3c5326b2d32830ca7677"
    sha256 cellar: :any, arm64_sequoia: "ffcf2b7d02a57b546a6e2fe26a445c7fd15c2119b248cc724dc1267657b1a2cb"
    sha256 cellar: :any, arm64_sonoma:  "9e2705809db94a1d000fe344b03e6938111445af224dba84e635c5c95800d470"
    sha256 cellar: :any, sonoma:        "e4718a90079ed67d912f2d48797beed1f863e51fcbc5e709ba46a202c9a55155"
    sha256 cellar: :any, arm64_linux:   "7da6820e01817cbc7e8d7b8c8687d9414f16cd044e93c2d9ec0d3aa4c632ab99"
    sha256 cellar: :any, x86_64_linux:  "f65fd73b669c2d7fc0ff363f7a9a4af57a89d45ed75b872f1a677a8db4d12d6b"
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