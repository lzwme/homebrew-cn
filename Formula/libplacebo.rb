class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  stable do
    url "https://code.videolan.org/videolan/libplacebo/-/archive/v5.264.1/libplacebo-v5.264.1.tar.bz2"
    sha256 "99ebcf90f3d3c6c4e5b9364091575b9b75d5a1a7d2356a60d8cf67d4fd93b5da"

    resource "glad" do
      url "https://files.pythonhosted.org/packages/8b/b3/191508033476b6a409c070c6166b1c41ebb547cc6136260e9157343e6a2b/glad2-2.0.4.tar.gz"
      sha256 "ede1639f69f2ba08f1f498a40a707f34a609d24eb2ea0d6c9364689a798cf7d0"
    end

    resource "jinja" do
      url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
      sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
    end

    resource "markupsafe" do
      url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
      sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2c597b7a0957b220b91bc2123abc33a04cdf63710d4a9fa6493be031e57e07f3"
    sha256 cellar: :any,                 arm64_monterey: "9c80ebfa61ae41fd54c97014db437ff5c17b9bc6a220d0cdd14eff22320c1fd7"
    sha256 cellar: :any,                 arm64_big_sur:  "f59a1b228f2c720e5889f19799b7de6552b255c77ff820a3634660667b399ca4"
    sha256 cellar: :any,                 ventura:        "8706776b31155a54db09a06d049673c9667522e5c632fbe167c787a30c17260a"
    sha256 cellar: :any,                 monterey:       "9bd97a25debddec6f2b8d186945127235c9cbb0951a7361fd7901149ff3e913a"
    sha256 cellar: :any,                 big_sur:        "b7d363abde8eb1c7ee676089223eef6ca1afa94535ccc3fb1252937e03581d9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a20c8536a4d5d64c00b01c8a947f30140e79f6ab02c099e4a23bdd9ef41bc3f1"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-headers" => :build

  depends_on "ffmpeg"
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