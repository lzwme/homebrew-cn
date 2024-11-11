class DmtxUtils < Formula
  desc "Read and write data matrix barcodes"
  homepage "https:github.comdmtxdmtx-utils"
  url "https:github.comdmtxdmtx-utilsarchiverefstagsv0.7.6.tar.gz"
  sha256 "0d396ec14f32a8cf9e08369a4122a16aa2e5fa1675e02218f16f1ab777ea2a28"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c5c39f74e46f11e5ec7981d8bc5c3bb8dcbe372d337487fc17ffb10308bfc63d"
    sha256 cellar: :any,                 arm64_sonoma:  "213cd0921574a2f8d2188db99fe70d4cbeab0ce846bb4af22965287d389748c5"
    sha256 cellar: :any,                 arm64_ventura: "6e047ce6b7421e233f68c3fd471e445df9eb438e62f5267f19e5d200e0154573"
    sha256 cellar: :any,                 sonoma:        "5db28571133af052c05a62617d80e2b079126a3ffedc536eb8fa1f66f355d8c0"
    sha256 cellar: :any,                 ventura:       "c39fe0239d30c55fb0099af364a422625247104514fb92eb6c52249a21893aa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f51b82ef16b29ead50fa9a2535af3a33af667faac3524c6fb6e5d493ea9cfd4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build

  depends_on "imagemagick"
  depends_on "libdmtx"
  depends_on "libtool"

  on_macos do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "gettext"
    depends_on "glib"
    depends_on "liblqr"
    depends_on "libomp"
    depends_on "little-cms2"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system ".configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    resource "homebrew-test_image12" do
      url "https:raw.githubusercontent.comdmtxlibdmtxca9313ftestrotate_testimagestest_image12.png"
      sha256 "683777f43ce2747c8a6c7a3d294f64bdbfee600d719aac60a18fcb36f7fc7242"
    end

    testpath.install resource("homebrew-test_image12")
    image = File.read("test_image12.png")
    assert_equal "9411300724000003", pipe_output("#{bin}dmtxread", image, 0)
    system "bindd", "if=devrandom", "of=in.bin", "bs=512", "count=3"
    dmtxwrite_output = pipe_output("#{bin}dmtxwrite", File.read("in.bin"), 0)
    dmtxread_output = pipe_output("#{bin}dmtxread", dmtxwrite_output, 0)
    (testpath"out.bin").atomic_write dmtxread_output
    assert_equal (testpath"in.bin").sha256, (testpath"out.bin").sha256
  end
end