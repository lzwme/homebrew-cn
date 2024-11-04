class Pytorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https:pytorch.org"
  url "https:github.compytorchpytorchreleasesdownloadv2.4.1pytorch-v2.4.1.tar.gz"
  sha256 "39666a43c0c10f5fd46c1a7ca95dc74d3bc39de2678b70066481cbf02e58384f"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "af8159441b06d5e515ee322c5ad5cea34b77785b3b19189ec1423c907da8dbe2"
    sha256 cellar: :any,                 arm64_sonoma:  "b81aa0d36dc3b4abf0011c1d3bbf037732c46b0b8f71bf1c9566eac9776e8456"
    sha256 cellar: :any,                 arm64_ventura: "e3e24bec6c7ba3d8d013ecee3451fe6ef9c0fe928f2bce41741049da7a42d734"
    sha256 cellar: :any,                 sonoma:        "46b835c31dc28d562d4776e33936fa2fe98f0e9f5a46e2b329fb6e358e558eb7"
    sha256 cellar: :any,                 ventura:       "ddd63ae057e01976336f09969047eac05de9ab771aa380079aca39470cb44267"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a74d817a047a1f3242fecdf4560a8c1a659722034889cc5e36c49cf56343968"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on xcode: :build
  depends_on "abseil"
  depends_on "eigen"
  depends_on "libuv"
  depends_on "libyaml"
  depends_on macos: :monterey # MPS backend only supports 12.3 and above
  depends_on "numpy"
  depends_on "openblas"
  depends_on "protobuf"
  depends_on "pybind11"
  depends_on "sleef"

  on_macos do
    depends_on "libomp"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages9ddb3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "fsspec" do
    url "https:files.pythonhosted.orgpackages627c12b0943011daaaa9c35c2a2e22e5eb929ac90002f08f1259d69aedad84defsspec-2024.9.0.tar.gz"
    sha256 "4b0afb90c2f21832df142f292649035d80b421f60a9e1c027802e5a0da2b04e8"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mpmath" do
    url "https:files.pythonhosted.orgpackagese047dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackages04e6b164f94c869d6b2c605b5128b7b0cfe912795a87fc90e78533920001f3ecnetworkx-3.3.tar.gz"
    sha256 "0c127d8b2f4865f59ae9cb8aafcd60b5c70f3241ebd66f7defad7c4ab90126c9"
  end

  resource "opt-einsum" do
    url "https:files.pythonhosted.orgpackages7dbf9257e53a0e7715bc1127e15063e831f076723c6cd60985333a1c18878fb8opt_einsum-3.3.0.tar.gz"
    sha256 "59f6475f77bbc37dcf7cd748519c0ec60722e91e63ca114e68821c0c54a46549"

    # Backport ConfigParser fix for Python 3.12 support
    patch do
      url "https:github.comdgasmithopt_einsumcommit7c8f193f90b6771a6b3065bb5cf6ec2747af8209.patch?full_index=1"
      sha256 "7c90ac470278deca8aa9d7ecb4bb2b31a2f79928e1783ae1316fcc3aa81f348a"
    end
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages27b8f21073fde99492b33ca357876430822e4800cdf522011f18041351dfa74bsetuptools-75.1.0.tar.gz"
    sha256 "d59a21b17a275fb872a9c3dae73963160ae079f1049ed956880cd7c09b120538"
  end

  resource "sympy" do
    url "https:files.pythonhosted.orgpackages118a5a7fd6284fa8caac23a26c9ddf9c30485a48169344b4bd3b0f02fef1890fsympy-1.13.3.tar.gz"
    sha256 "b27fd2c6530e0ab39e275fc9b683895367e51d5da91baa8d3d64db2565fec4d9"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    python3 = "python3.12"

    # Avoid building AVX512 code
    inreplace "cmakeModulesFindAVX.cmake", ^CHECK_SSE\(CXX "AVX512", "#\\0"

    ENV["ATEN_NO_TEST"] = "ON"
    ENV["BLAS"] = "OpenBLAS"
    ENV["BUILD_CUSTOM_PROTOBUF"] = "OFF"
    ENV["BUILD_PYTHON"] = "ON"
    ENV["BUILD_TEST"] = "OFF"
    ENV["PYTHON_EXECUTABLE"] = which(python3)
    ENV["PYTORCH_BUILD_VERSION"] = version.to_s
    ENV["PYTORCH_BUILD_NUMBER"] = "1"
    ENV["USE_CCACHE"] = "OFF"
    ENV["USE_CUDA"] = "OFF"
    ENV["USE_DISTRIBUTED"] = "ON"
    ENV["USE_MKLDNN"] = "OFF"
    ENV["USE_NNPACK"] = "OFF"
    ENV["USE_OPENMP"] = "ON"
    ENV["USE_SYSTEM_EIGEN_INSTALL"] = "ON"
    ENV["USE_SYSTEM_PYBIND11"] = "ON"
    ENV["USE_SYSTEM_SLEEF"] = "ON"
    ENV["USE_MPS"] = "ON" if OS.mac?

    # Work around superenv removing `-Werror=` but leaving `-Wno-error=` breaking flag detection
    if ENV.compiler.to_s.start_with?("gcc")
      inreplace "CMakeLists.txt", ^\s*append_cxx_flag_if_supported\(\s*"-Wno-error=inconsistent-missing-[^)]*\), ""
    end

    # Avoid references to Homebrew shims
    inreplace "caffe2coremacros.h.in", "${CMAKE_CXX_COMPILER}", ENV.cxx

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources
    venv.pip_install_and_link(buildpath, build_isolation: false)

    # Expose C++ API
    torch = venv.site_packages"torch"
    include.install_symlink (torch"include").children
    lib.install_symlink (torch"lib").children
    (share"cmake").install_symlink (torch"sharecmake").children
  end

  test do
    # test that C++ libraries are available
    (testpath"test.cpp").write <<~CPP
      #include <torchtorch.h>
      #include <iostream>

      int main() {
        torch::Tensor tensor = torch::rand({2, 3});
        std::cout << tensor << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}torchcsrcapiinclude",
                    "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10"
    system ".test"

    # test that the `torch` Python module is available
    system libexec"binpython", "-c", <<~PYTHON
      import torch
      t = torch.rand(5, 3)
      assert isinstance(t, torch.Tensor), "not a tensor"
      assert torch.distributed.is_available(), "torch.distributed is unavailable"
    PYTHON
    return unless OS.mac?

    # test that we have the MPS backend
    system libexec"binpython", "-c", <<~PYTHON
      import torch
      assert torch.backends.mps.is_built(), "MPS backend is not built"
    PYTHON
  end
end