class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  stable do
    url "https://code.videolan.org/videolan/libplacebo/-/archive/v6.292.0/libplacebo-v6.292.0.tar.bz2"
    sha256 "9182be99fc5e27f64e9193ba371380b10d5f78d09836c0afad1d3998f275e72b"

    resource "glad" do
      url "https://files.pythonhosted.org/packages/8b/b3/191508033476b6a409c070c6166b1c41ebb547cc6136260e9157343e6a2b/glad2-2.0.4.tar.gz"
      sha256 "ede1639f69f2ba08f1f498a40a707f34a609d24eb2ea0d6c9364689a798cf7d0"
    end

    resource "jinja" do
      url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
      sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
    end

    resource "markupsafe" do
      url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
      sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ef2cdb463d5cc6883c9aca3ad6f82553137dfb66a95a32f4abc6225590fc891f"
    sha256 cellar: :any,                 arm64_monterey: "4dd86c5be068fa21dade9e0633f245825f8da0131d130dcf2316a88f935c63d7"
    sha256 cellar: :any,                 arm64_big_sur:  "d694a3ea2c6e1ff63461fc6870436c03ca21d0ce6f9d870c1b3d57dac30f9ccf"
    sha256 cellar: :any,                 ventura:        "9d0263916c5e0b94553ae8429b567eb62264cdc17eabfaa6195d1757ef265b41"
    sha256 cellar: :any,                 monterey:       "deec8934c543463786e7b79e65fa9c436b63849bb7396dbea3c238db2f9db0c1"
    sha256 cellar: :any,                 big_sur:        "a87b28f82b5c9a2de7295524649836dceea54c705be1f3cfd1bcdaa34d782278"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0045d06759773a7066e824330255ad8c6a64dc68d621194003e5eccd56c2fad"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-headers" => :build

  depends_on "glslang"
  depends_on "little-cms2"
  depends_on "sdl2"
  depends_on "vulkan-loader"

  def install
    resources.each do |r|
      r.stage(Pathname("3rdparty")/r.name)
    end

    system "meson", "setup", "build",
                    "-Dvulkan-registry=#{Formula["vulkan-headers"].share}/vulkan/registry/vk.xml",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libplacebo/config.h>
      #include <stdlib.h>
      int main() {
        return (pl_version() != NULL) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lplacebo"
    system "./test"
  end
end