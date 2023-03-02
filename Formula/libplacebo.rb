class Libplacebo < Formula
  include Language::Python::Virtualenv

  desc "Reusable library for GPU-accelerated image/video processing primitives"
  homepage "https://code.videolan.org/videolan/libplacebo"
  license "LGPL-2.1-or-later"
  head "https://code.videolan.org/videolan/libplacebo.git", branch: "master"

  stable do
    url "https://code.videolan.org/videolan/libplacebo/-/archive/v5.229.2/libplacebo-v5.229.2.tar.bz2"
    sha256 "34424f509590e03b99ff1d3bc1c99e4f6bcb8999fdb27da51f25d91e375402a6"

    resource "glad" do
      url "https://files.pythonhosted.org/packages/e5/5f/a88837847083930e289e1eee93a9376a0a89a2a373d148abe7c804ad6657/glad2-2.0.2.tar.gz"
      sha256 "c2d1c51139a25a36dbadeef08604347d1c8d8cc1623ebed88f7eb45ade56379e"
    end

    resource "jinja" do
      url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
      sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
    end

    resource "markupsafe" do
      url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
      sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "4fb36fcfceb4581bb098b416de4ecefba168c7e7571573ee6e76bd85dae2c2e6"
    sha256 cellar: :any, arm64_monterey: "7b2f9758e160a7e54fb4c99695365e274a7dc48b09abc303d0311dbc9e0ef4e0"
    sha256 cellar: :any, arm64_big_sur:  "c0db0b06184332f4cfca6a819ec53b69f30c46f49c56d9d6154cba20acbb02e3"
    sha256 cellar: :any, ventura:        "e1afac9c267daf30f6d522b390f566875b84dc81e3e09aab6ae5f0457e89ad25"
    sha256 cellar: :any, monterey:       "99b89e0d5db756b28f7abffe43e28164635ac3a9f833e345eea02f8726dc3f49"
    sha256 cellar: :any, big_sur:        "2928d5e40b4d5a7e8f2b562237d25812c8846e00765ba3ef4c989116292c004d"
    sha256               x86_64_linux:   "d9a6ec197f30b9107fd0e414d2d8f7993854191e9b9baae251101e141f00db79"
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