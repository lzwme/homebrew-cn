class Pytorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https:pytorch.org"
  url "https:github.compytorchpytorchreleasesdownloadv2.5.1pytorch-v2.5.1.tar.gz"
  sha256 "740eb5fff95e33cfe699bad43be83523f569c7cc7f9c285c2a255416443dd266"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "63fa9f32fdc1ad8ccf8df2a7dcde7e0abb67336b2f4c33cd613c4dfda736438f"
    sha256 cellar: :any,                 arm64_sonoma:  "da20035d9a1813735459cb044ef541aa2c55078e50d948b919d550d68b8ca3e2"
    sha256 cellar: :any,                 arm64_ventura: "0b10b0fe15b2352e3d02d82ca3fb97b1806da8485a3b5355d0dcea51b60fe7f3"
    sha256 cellar: :any,                 sonoma:        "1132c68ecb8865a2b3865112f9e135e5d11ed2f12a2486d18c032ec2373292f5"
    sha256 cellar: :any,                 ventura:       "f847674dfb721254cc4b7f41f243e02aea2ebe46808ed70b97296421dfac2107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e5e98938d7d124e2fce406b552f828f2fc1b3b052b5e4db96ae1144d36a3222"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.13" => [:build, :test]
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
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mpmath" do
    url "https:files.pythonhosted.orgpackagese047dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https:files.pythonhosted.orgpackages362b20ad9eecdda3f1b0dc63fb8f82d2ea99163dbca08bfa392594fc2ed81869networkx-3.4.1.tar.gz"
    sha256 "f9df45e85b78f5bd010993e897b4f1fdb242c11e015b101bd951e5c0e29982d8"
  end

  resource "opt-einsum" do
    url "https:files.pythonhosted.orgpackages8cb92ac072041e899a52f20cf9510850ff58295003aa75525e58343591b0cbfbopt_einsum-3.4.0.tar.gz"
    sha256 "96ca72f1b886d148241348783498194c577fa30a8faac108586b14f1ba4473ac"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages0737b31be7e4b9f13b59cde9dcaeff112d401d49e0dc5b37ed4a9fc8fb12f409setuptools-75.2.0.tar.gz"
    sha256 "753bb6ebf1f465a1912e19ed1d41f403a79173a9acf66a42e7e6aec45c3c16ec"
  end

  resource "sympy" do
    url "https:files.pythonhosted.orgpackagesca995a5b6f19ff9f083671ddf7b9632028436167cd3d33e11015754e41b249a4sympy-1.13.1.tar.gz"
    sha256 "9cebf7e04ff162015ce31c9c6c9144daa34a93bd082f54fd8f12deca4f47515f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  def install
    python3 = "python3.13"

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