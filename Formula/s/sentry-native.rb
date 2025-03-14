class SentryNative < Formula
  desc "Sentry SDK for C, C++ and native applications"
  homepage "https:docs.sentry.ioplatformsnative"
  url "https:github.comgetsentrysentry-nativearchiverefstags0.8.1.tar.gz"
  sha256 "65e3de5708e57f30e821a474f7bdd02bb8ccafd97b5553ec8ecb1791a161ef3d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bb88bd85d644a3143498af7de7aa6bfa1829d7aa74597288e806af99a22ea42b"
    sha256 cellar: :any,                 arm64_sonoma:  "9ec6af2ada5caf735c422a6989b879e0afa104c0d8fdb582055a52fd3db632b6"
    sha256 cellar: :any,                 arm64_ventura: "53ee50fc8d60ae5599fab68b9d8ced1b1b6e31647f99321778747c8397a0d588"
    sha256 cellar: :any,                 sonoma:        "355846b2dd1f3a74663c297956523988fa579d131c9dc469d629c2900ffa602a"
    sha256 cellar: :any,                 ventura:       "14cecef7d13f4be1781f36e1bded6f436b5d77c0935abc6a537a384e078470d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1b80b8f129431ba46f99e8497654019887bc9ef32f05fd92936060489372ee5"
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