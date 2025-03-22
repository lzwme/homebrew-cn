class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https:docs.sentry.ioplatformsnative"
  url "https:github.comgetsentrysentry-nativearchiverefstags0.8.2.tar.gz"
  sha256 "37a7ca1f85bcad4663d1fe7e9f0e302041c7a5c64aae222408db6cf876bc2f8b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cc8ac48c37c3a65fc5f8e54c99598b364091295b5deb40d8b91bedb138269aa8"
    sha256 cellar: :any,                 arm64_sonoma:  "fadd243287c272fedf8c87460e681a9a0f288eea5d4eab2e79b25349cffaf44a"
    sha256 cellar: :any,                 arm64_ventura: "c6897bb16e462bc1c5d0770ec4875005da06754f6572817d49e80c11346a6109"
    sha256 cellar: :any,                 sonoma:        "8182ade24b56eea64719f6ab9de9cb8b91bdd17a7fb364de55989b3a7a10036b"
    sha256 cellar: :any,                 ventura:       "30ed938fffae3a190db6edbef2684ceafe5b63f359f5160494c16d05bee8f7af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5625d9bf081acafc00c7193c17be523e77d6bea9fd9bee08adf23440a184586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddebd3b39ba098d60e532eff10611186a220653ac17b89a007241225d653c5ba"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  # No recent tagged releases, so we use the latest commit as of 2025-Mar-10
  resource "breakpad" do
    url "https:github.comgetsentrybreakpad.git",
        revision: "ecff426597666af4231da8505a85a61169c5ab04"
  end

  # No recent tagged releases, so we use the latest commit as of 2025-Mar-10
  resource "crashpad" do
    url "https:github.comgetsentrycrashpad.git",
        revision: "4cd23a2bedb49751d871da086b20b66888562924"
  end

  # No recent tagged releases, so we use the latest commit as of 2025-Mar-10
  resource "libunwindstack-ndk" do
    url "https:github.comgetsentrylibunwindstack-ndk.git",
        revision: "284202fb1e42dbeba6598e26ced2e1ec404eecd1"
  end

  resource "third-partylss" do
    url "https:chromium.googlesource.comlinux-syscall-support.git",
        tag:      "v2024.02.01",
        revision: "ed31caa60f20a4f6569883b2d752ef7522de51e0"
  end

  def install
    resources.each { |r| r.stage buildpath"external"r.name }
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.c").write <<~C
      #include <sentry.h>
      int main() {
        sentry_options_t *options = sentry_options_new();
        sentry_options_set_dsn(options, "https:ABC.ingest.us.sentry.io123");
        sentry_init(options);
        sentry_close();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{HOMEBREW_PREFIX}include", "-L#{HOMEBREW_PREFIX}lib", "-lsentry", "-o", "test"
    system ".test"
  end
end