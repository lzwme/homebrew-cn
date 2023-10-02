class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  stable do
    url "https://code.videolan.org/videolan/libplacebo/-/archive/v6.338.0/libplacebo-v6.338.0.tar.bz2"
    sha256 "256c5cb01cafddc341bb7cd4df9b17f7e92b943e6cf5696ec1bd5cd1d5a381c8"

    resource "fast_float" do
      url "https://ghproxy.com/https://github.com/fastfloat/fast_float/archive/refs/tags/v5.2.0.tar.gz"
      sha256 "72bbfd1914e414c920e39abdc81378adf910a622b62c45b4c61d344039425d18"
    end

    resource "glad2" do
      url "https://files.pythonhosted.org/packages/8b/b3/191508033476b6a409c070c6166b1c41ebb547cc6136260e9157343e6a2b/glad2-2.0.4.tar.gz"
      sha256 "ede1639f69f2ba08f1f498a40a707f34a609d24eb2ea0d6c9364689a798cf7d0"
    end

    resource "jinja2" do
      url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
      sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
    end

    resource "markupsafe" do
      url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
      sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f5c9a06e13dd825f4d48e82ea6002fd4d7d8883d41f1b32c850ef711be01d1ce"
    sha256 cellar: :any,                 arm64_ventura:  "68223c2bd93eaebfe65e4c1cf4451ba30c6a580b872f3ced4927a3c01d71b503"
    sha256 cellar: :any,                 arm64_monterey: "919337809c0a2b87539ffd9b848af5537869598834e0b0a99281ee2930b74a15"
    sha256 cellar: :any,                 sonoma:         "3a3375f51275ed05ddba0c4058272bc7286e05a973da9e490531418ee79053e8"
    sha256 cellar: :any,                 ventura:        "844927cb7086ffaef1d3e5d56028494ecdc7dacb63bbb39a47fff95a7817e8bd"
    sha256 cellar: :any,                 monterey:       "8aadca199d518901febb930669278ed4bd877308722c443e55021c82d74add17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a180e51555a44b34fac243cdd5bb8878c4bea545de37526f2b43b90d8bb14d7"
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
      # Override resource name to use expected directory name
      dir_name = case r.name
      when "glad2", "jinja2"
        r.name.sub(/\d+$/, "")
      else
        r.name
      end

      r.stage(Pathname("3rdparty")/dir_name)
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