class Torchvision < Formula
  include Language::Python::Virtualenv

  desc "Datasets, transforms, and models for computer vision"
  homepage "https:github.compytorchvision"
  url "https:github.compytorchvisionarchiverefstagsv0.19.1.tar.gz"
  sha256 "083e75c467285595ec3eb3c7aa8493c19e53d7eb42f13046fb56a07c8897e5a8"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9c465c861116f5dbec7b375f48b2fda9ad273632a372f681647ab77157d05401"
    sha256 cellar: :any,                 arm64_sonoma:  "16506991bd75837ff07807a22a4c15367d3a44d81f8dbb9e412aa46533b46e0f"
    sha256 cellar: :any,                 arm64_ventura: "163ee42a74b4ab7c0fc3f424e29da87929a36b67c23ae409473be505c0fb8f97"
    sha256 cellar: :any,                 sonoma:        "569b195c4bde41d5ec1d0c253c38f06b6701ba49b260adf9889626c73b669499"
    sha256 cellar: :any,                 ventura:       "fdd303661561260dc204dcdfd14f9b6ae617e6b2c6416118e3e33924735cfa55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a1090d1598b7a517694b51c14a33b835db4609fe71adfd9af7196719e8c5f07"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "abseil"
  depends_on "certifi"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "protobuf"
  depends_on "pytorch"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    jpeg = Formula["jpeg-turbo"]
    inreplace "setup.py",
      "(jpeg_found, jpeg_conda, jpeg_include, jpeg_lib) = find_library(\"jpeglib\", vision_include)",
      "(jpeg_found, jpeg_conda, jpeg_include, jpeg_lib) = (True, False, \"#{jpeg.include}\", \"#{jpeg.lib}\")"

    python3 = "python3.12"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    # We depend on pytorch, but that's a separate formula, so install a `.pth` file to link them.
    # This needs to happen _before_ we try to install torchvision.
    # NOTE: This is an exception to our usual policy as building `pytorch` is complicated
    site_packages = Language::Python.site_packages(python3)
    pth_contents = "import site; site.addsitedir('#{Formula["pytorch"].opt_libexecsite_packages}')\n"
    (venv.site_packages"homebrew-pytorch.pth").write pth_contents

    venv.pip_install_and_link(buildpath, build_isolation: false)

    pkgshare.install "examples"
  end

  test do
    # test that C++ libraries are available
    # See also https:github.compytorchvisionissues2134#issuecomment-1793846900
    (testpath"test.cpp").write <<~EOS
      #include <assert.h>
      #include <torchscript.h>
      #include <torchtorch.h>
      #include <torchvisionvision.h>
      #include <torchvisionopsnms.h>

      int main() {
        auto& ops = torch::jit::getAllOperatorsFor(torch::jit::Symbol::fromQualString("torchvision::nms"));
        assert(ops.size() == 1);
      }
    EOS
    pytorch = Formula["pytorch"]
    openmp_flags = if OS.mac?
      libomp = Formula["libomp"]
      %W[
        -Xpreprocessor -fopenmp
        -I#{libomp.opt_include}
        -L#{libomp.opt_lib} -lomp
      ]
    else
      %w[-fopenmp]
    end
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *openmp_flags,
                    "-I#{pytorch.opt_include}",
                    "-I#{pytorch.opt_include}torchcsrcapiinclude",
                    "-L#{pytorch.opt_lib}", "-ltorch", "-ltorch_cpu", "-lc10",
                    "-L#{lib}", *("-Wl,--no-as-needed" if OS.linux?), "-ltorchvision"

    system ".test"

    # test that the `torchvision` Python module is available
    cp test_fixtures("test.png"), "test.png"
    system libexec"binpython", "-c", <<~EOS
      import torch
      import torchvision
      t = torchvision.io.read_image("test.png")
      assert isinstance(t, torch.Tensor)
    EOS
  end
end