class Torchvision < Formula
  include Language::Python::Virtualenv

  desc "Datasets, transforms, and models for computer vision"
  homepage "https:github.compytorchvision"
  url "https:github.compytorchvisionarchiverefstagsv0.17.0.tar.gz"
  sha256 "55e395d5c7d9bf7658c82ac633cac2224aa168e1bfe8bb5b2b2a296c792a3500"
  license "BSD-3-Clause"
  revision 5

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "00ec3371f348541cbfe6e45d3c05cc54f3f65cd97ccd1698dadb1f432806107f"
    sha256 cellar: :any,                 arm64_ventura:  "30a4148f2a5668c1f9c92bf3ea986a616fdf71fccfac81be41984e4360e68279"
    sha256 cellar: :any,                 arm64_monterey: "996fab366b76fac5592b7d8c9a40c28e3719c9c792eacb745d35bf3795d39463"
    sha256 cellar: :any,                 sonoma:         "f934a34c8ecd3fdc3f56c2ca33664f6499d2bab5c23c30c7db952b1cf159618c"
    sha256 cellar: :any,                 ventura:        "22c40fefaf8b653622950d0b8307292fdbdd5301f55d5b4ba8612af1b1dbe5cc"
    sha256 cellar: :any,                 monterey:       "257200438bb32df54f44ac6baa13309b6ca8a602aba9fa79fdfdbd308ebd6f62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b790e890330c69f607b83cab455c81d9be5954831cbe42b909eb31dd4e689195"
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

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
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
    site_packages = Language::Python.site_packages(python3)
    pytorch = Formula["pytorch"].opt_libexec
    (libexecsite_packages"homebrew-pytorch.pth").write pytorchsite_packages

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