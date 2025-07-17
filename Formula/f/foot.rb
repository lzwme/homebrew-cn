class Foot < Formula
  desc "Fast, lightweight and minimalistic Wayland terminal emulator"
  homepage "https://codeberg.org/dnkl/foot"
  url "https://codeberg.org/dnkl/foot/archive/1.23.0.tar.gz"
  sha256 "74c874feb5ae0277a9f19fbd6418a40524cd71d629784276d109ebfe4e786421"
  license "MIT"

  bottle do
    sha256 arm64_linux:  "01535de1e3e5bbb2c115d89acac6652ad3ef53d9182766db281713224016c262"
    sha256 x86_64_linux: "566ba9ad15bd6a58d32473262df55dfb8fa3d01506c6812cec99e2d151deb10b"
  end

  depends_on "cmake" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "scdoc" => :build
  depends_on "tllist" => :build
  depends_on "wayland-protocols" => :build

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