class Xnvme < Formula
  desc "Cross-platform libraries and tools for efficient I/O and low-level control"
  homepage "https://xnvme.io/"
  url "https://ghproxy.com/https://github.com/OpenMPDK/xNVMe/releases/download/v0.7.2/xnvme-0.7.2.tar.gz"
  sha256 "1cb849b537cfddc15d82b8f4622fe3f999b4c7c0542c55b8d09b485e016e942e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "830f567b154ea9df0fdd892ecfa8f003a81d26f42fe887ec2227ab6de18aadae"
    sha256 cellar: :any,                 arm64_ventura:  "a12fe1d121afb52c9f4f5410f5583e74c9219159ccd0e3d46eb9227d342ddfbd"
    sha256 cellar: :any,                 arm64_monterey: "88adc7d6f8b4fa311963849e19eea159f2bf6c3a0c8cede32747bd3228002f22"
    sha256 cellar: :any,                 sonoma:         "2491c41820dd64410b86badc26f8beec6c26d935e82d048210ae13b2e405704c"
    sha256 cellar: :any,                 ventura:        "864a99143acff3569e21ce28c9df2a496dc87619668fd81678e93c50c04cd5b5"
    sha256 cellar: :any,                 monterey:       "1efcfd3804a055bd1c5336564ca37c237acc112c6228a3b8765097d80d104f76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46b46af58ae5a58229d6ddcb84e1d0cf4a4bc6816609dabf476c3f824231a36d"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.12" => :build

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