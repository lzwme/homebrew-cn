class Xnvme < Formula
  desc "Cross-platform libraries and tools for efficient I/O and low-level control"
  homepage "https://xnvme.io/"
  url "https://ghproxy.com/https://github.com/OpenMPDK/xNVMe/releases/download/v0.7.3/xnvme-0.7.3.tar.gz"
  sha256 "fb1b777e63ed2e6a256de6bd2718db346f6e78eb73ef188ff1aef526ce28f294"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "78f18d003e4b8bde3d43a5fae95b3b8c04d065bab323aac7286beda3fc93c261"
    sha256 cellar: :any,                 arm64_ventura:  "5130ed24dfd455e2c511414f9a0adbbd9ddf91567a3b5ce59923bf8206e19b4c"
    sha256 cellar: :any,                 arm64_monterey: "6bfc95c6573e3568693e2d5a58f9f624c08b68ca136dc66d87c1a25277e9f831"
    sha256 cellar: :any,                 sonoma:         "60c283760ad38a376b2ff0ba98775826fb40a76973842dd52236482df2c3ee35"
    sha256 cellar: :any,                 ventura:        "8464dd0c68aa28aa3b4673d7467eaa6aa4acd582cbff2ae9a8b78c20fee09322"
    sha256 cellar: :any,                 monterey:       "16b421921b495a64b1e783bd686e0de2027c82b5144bd1b5c4c058b39cade9e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f672e44c00cf323535356d2fcad60bc080dc6b4affcf6c7b3ca7218139dbdea7"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]

  def install
    # We do not have SPDK nor libvfn on macOS, thus disabling these
    # The examples and tests are also a bit superflous, so disable those as well
    system "meson", "setup", "build",
           *std_meson_args,
           "-Dwith-spdk=false",
           "-Dwith-libvfn=disabled",
           "-Dtests=false",
           "-Dexamples=false"
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    # Verify cli usage using a "ramdisk" of 1GB
    output = shell_output("#{bin}/xnvme library-info")
    assert_match "XNVME_BE_RAMDISK_ENABLED", output

    output = shell_output("#{bin}/xnvme info 1GB --be ramdisk")
    assert_match "uri: '1GB'", output
    assert_match "type: XNVME_GEO_CONVENTIONAL", output
    assert_match "tbytes: 1073741824", output

    # Verify library usage using a ramdisk of 1GB
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libxnvme.h>

      int main(int argc, char **argv) {
        struct xnvme_opts opts = xnvme_opts_default();
        struct xnvme_dev *dev;

        dev = xnvme_dev_open("1GB", &opts);
        if (!dev) {
          perror("xnvme_dev_open()");
          return 1;
        }

        xnvme_dev_pr(dev, XNVME_PR_DEF);
        xnvme_dev_close(dev);

        return 0;
      }
    EOS

    # Build the example using pkg-config for build-options
    flags = shell_output("pkg-config xnvme --libs --cflags").strip
    system ENV.cc, "test.c", "-o", "test", *flags.split

    # Run it and check the output, this should produce the same output as the
    # 'xnvme library-info' command, thus the output-assertion is the same
    output = shell_output("./test info 1GB --be ramdisk")
    assert_match "uri: '1GB'", output
    assert_match "type: XNVME_GEO_CONVENTIONAL", output
    assert_match "tbytes: 1073741824", output
  end
end