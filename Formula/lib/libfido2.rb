class Libfido2 < Formula
  desc "Provides library functionality for FIDO U2F & FIDO 2.0, including USB"
  homepage "https:developers.yubico.comlibfido2"
  url "https:github.comYubicolibfido2archiverefstags1.14.0.tar.gz"
  sha256 "3601792e320032d428002c4cce8499a4c7b803319051a25a0c9f1f138ffee45a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "394dfe89f44da488cb9c1ee038a40c5863f4a54516a2b002305bfa2bc0e3fe8e"
    sha256 cellar: :any,                 arm64_ventura:  "e67b1493edd1d886d0112ed8ca66a3ae8f37f12cc279e37e407ef47f99d92312"
    sha256 cellar: :any,                 arm64_monterey: "4519a4e98d7780ce9fd77a19f1dcf0d2f65cb63ddaec64b543added220656211"
    sha256 cellar: :any,                 sonoma:         "5a03d5e70e42f7316de5f9ad704cfa4231b95cb99752590655973593e1da10bc"
    sha256 cellar: :any,                 ventura:        "132066884bb12dfdd84ff49070f59c5abba3e601b22704482124186ddd9ce5e5"
    sha256 cellar: :any,                 monterey:       "ed5bb813b18f0ba971d01ee1d3008db5c33c5fcf58ca11e8af3a7178b2c80901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e52c57b1fa0230d20b6e18465ffe3bf1eec73cc408725ebe5b1a3cecff281b3d"
  end

  depends_on "cmake" => :build
  depends_on "mandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "libcbor"
  depends_on "openssl@3"

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    args = std_cmake_args

    args << "-DUDEV_RULES_DIR=#{lib}udevrules.d" if OS.linux?

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "man_symlink_html"
      system "make", "man_symlink"
      system "make", "install"
    end
  end

  test do
    (testpath"test.c").write <<-EOF
    #include <stddef.h>
    #include <stdio.h>
    #include <fido.h>
    int main(void) {
      fido_init(FIDO_DEBUG);
       Attempt to enumerate up to five FIDOU2F devices. Five is an arbitrary number.
      size_t max_devices = 5;
      fido_dev_info_t *devlist;
      if ((devlist = fido_dev_info_new(max_devices)) == NULL)
        return 1;
      size_t found_devices = 0;
      int error;
      if ((error = fido_dev_info_manifest(devlist, max_devices, &found_devices)) == FIDO_OK)
        printf("FIDOU2F devices found: %s\\n", found_devices ? "Some" : "None");
      fido_dev_info_free(&devlist, max_devices);
    }
    EOF
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["openssl@3"].include}", "-o", "test",
                   "-L#{lib}", "-lfido2"
    system ".test"
  end
end