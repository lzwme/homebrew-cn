class Foot < Formula
  desc "Fast, lightweight and minimalistic Wayland terminal emulator"
  homepage "https://codeberg.org/dnkl/foot"
  url "https://codeberg.org/dnkl/foot/archive/1.20.0.tar.gz"
  sha256 "e3d2fd87ff3a8d5b849b6766374d1e660256c3194916e4ef75ab7382d8756fc5"
  license "MIT"

  bottle do
    sha256 x86_64_linux: "53b4a7db62daaa050607d0d5d7824e9261a06f395543306371641c03c5b6224e"
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

    config_file.write <<~INI
      [cursor]
      style=blok
    INI

    assert_match(
      /blok: not one of 'block', 'underline', 'beam'/,
      shell_output("#{bin}/foot --check-config 2>&1", 230),
    )

    rm(config_file)
    config_file.write <<~INI
      [cursor]
      style=block
    INI

    assert_empty shell_output("#{bin}/foot --check-config")
  end
end