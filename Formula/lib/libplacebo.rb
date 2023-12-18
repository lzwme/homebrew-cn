class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated imagevideo processing primitives"
  homepage "https:code.videolan.orgvideolanlibplacebo"
  license "LGPL-2.1-or-later"
  revision 1
  head "https:code.videolan.orgvideolanlibplacebo.git", branch: "master"

  stable do
    url "https:code.videolan.orgvideolanlibplacebo-archivev6.338.1libplacebo-v6.338.1.tar.bz2"
    sha256 "66f173e511884ad96c23073e6c3a846215db804f098e11698132abe5a63d6f72"

    resource "fast_float" do
      url "https:github.comfastfloatfast_floatarchiverefstagsv5.2.0.tar.gz"
      sha256 "72bbfd1914e414c920e39abdc81378adf910a622b62c45b4c61d344039425d18"
    end

    resource "glad2" do
      url "https:files.pythonhosted.orgpackages8bb3191508033476b6a409c070c6166b1c41ebb547cc6136260e9157343e6a2bglad2-2.0.4.tar.gz"
      sha256 "ede1639f69f2ba08f1f498a40a707f34a609d24eb2ea0d6c9364689a798cf7d0"
    end

    resource "jinja2" do
      url "https:files.pythonhosted.orgpackages7aff75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cceJinja2-3.1.2.tar.gz"
      sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "577a51429582caf30d0d24247b1b626393bce79e73a0a49794d2dba8da7c90d6"
    sha256 cellar: :any, arm64_ventura:  "2c55ed71dbbfba03e4c640f9983fe2f1efaf67277a7fc763251ed1c3c6a255e9"
    sha256 cellar: :any, arm64_monterey: "ca90a437a9336825fe6a6e871d73d5281a34b4f7843a5159747f2d2352c5e7ff"
    sha256 cellar: :any, sonoma:         "2c77c0e0ada6e5122f9ad19695e6ee58fa1e00047adb3e50a4f36c64fe8399ff"
    sha256 cellar: :any, ventura:        "97dd7cf5f6e6e1e1f50204a0daa3ccf8786c7761d442d58cc1194e6edbacefb1"
    sha256 cellar: :any, monterey:       "f947b0e79a977b544e1ecc38c7aa2af8ffa9f4011299c7a0bdc48fc863d83781"
    sha256               x86_64_linux:   "e7fa0f3a2f564af33caf681ec0e871d75664191f8fa7f9e28641e7d1e9291897"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-headers" => :build

  depends_on "little-cms2"
  depends_on "python-markupsafe"
  depends_on "shaderc"
  depends_on "vulkan-loader"

  def install
    resources.each do |r|
      # Override resource name to use expected directory name
      dir_name = case r.name
      when "glad2", "jinja2"
        r.name.sub(\d+$, "")
      else
        r.name
      end

      r.stage(Pathname("3rdparty")dir_name)
    end

    system "meson", "setup", "build",
                    "-Dvulkan-registry=#{Formula["vulkan-headers"].share}vulkanregistryvk.xml",
                    "-Dshaderc=enabled", "-Dvulkan=enabled", "-Dlcms=enabled",
                    *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath"test.c").write <<~EOS
      #include <libplaceboconfig.h>
      #include <stdlib.h>
      int main() {
        return (pl_version() != NULL) ? 0 : 1;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}",
                   "-L#{lib}", "-lplacebo"
    system ".test"
  end
end