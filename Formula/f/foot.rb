class Foot < Formula
  desc "Fast, lightweight and minimalistic Wayland terminal emulator"
  homepage "https://codeberg.org/dnkl/foot"
  url "https://codeberg.org/dnkl/foot/archive/1.19.0.tar.gz"
  sha256 "148b0b545ca37e15b877ff9f6a768a4ce6feb0ed256f8a5f853cb2e16e3323c1"
  license "MIT"

  bottle do
    sha256 x86_64_linux: "282b21536326523d6fea3cf14c9f1cc70eb20ab55d2ae2ed958b4b4b8071229a"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "scdoc" => :build
  depends_on "tllist" => :build

  depends_on "fcft"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libxkbcommon"
  depends_on :linux
  depends_on "pixman"
  depends_on "utf8proc"
  depends_on "wayland"

  def install
    system "meson", "setup", "build", "-Dterminfo-base-name=foot-extra", "-Ddocs=enabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    config_dir = testpath/".config/foot"
    config_file = config_dir/"foot.ini"

    mkdir_p config_dir

    File.write config_file, <<-EOF
      [cursor]
      style=blok
    EOF

    assert_match(
      /blok: not one of 'block', 'underline', 'beam'/,
      shell_output("#{bin}/foot --check-config 2>&1", 230),
    )

    File.write config_file, <<-EOF
      [cursor]
      style=block
    EOF

    assert_empty shell_output("#{bin}/foot --check-config")
  end
end