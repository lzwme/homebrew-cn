class Pytorch < Formula
  include Language::Python::Virtualenv

  desc "Tensors and dynamic neural networks"
  homepage "https:pytorch.org"
  url "https:github.compytorchpytorch.git",
      tag:      "v2.1.0",
      revision: "7bcf7da3a268b435777fe87c7794c382f444e86d"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "1e04904eefe2362abf5bb2a7b268bc918c7e15644fc44e484f52dab5e9bc7265"
    sha256 cellar: :any,                 arm64_ventura:  "596151cc5e64e57b03fe2a25305a302bf421e9b128fce82e45731a637c2c54d3"
    sha256 cellar: :any,                 arm64_monterey: "91650359defe1da8775fc260b3e481214a46b3b7ec79efab32f97a314ea95e91"
    sha256 cellar: :any,                 sonoma:         "4db1789590deeb347ffb1bcea8bb36e0d9049437b0fb48fffc28855724cbe0c1"
    sha256 cellar: :any,                 ventura:        "6175ae382a2dad45844a60081670cb2569d8ec7f26dfba57062ce3e084e2d1d3"
    sha256 cellar: :any,                 monterey:       "3b8654206fcf0872831f73e84911e22f8b297a8be12ea59b5ca7586ac5828ee0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16355062ead50b480b29ec1db4d4cccce737beb7a0ec807c2e44d497e740ef19"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on xcode: :build
  depends_on "eigen"
  depends_on "libuv"
  depends_on macos: :monterey # MPS backend only supports 12.3 and above
  depends_on "numpy"
  depends_on "openblas"
  depends_on "protobuf"
  depends_on "pybind11"
  depends_on "python-filelock"
  depends_on "python-jinja"
  depends_on "python-networkx"
  depends_on "python-sympy"
  depends_on "python-typing-extensions"
  depends_on "pyyaml"

  on_macos do
    depends_on "libomp"
  end

  conflicts_with "fmt", because: "both install `includefmtargs.h` headers"

  resource "opt-einsum" do
    url "https:files.pythonhosted.orgpackages7dbf9257e53a0e7715bc1127e15063e831f076723c6cd60985333a1c18878fb8opt_einsum-3.3.0.tar.gz"
    sha256 "59f6475f77bbc37dcf7cd748519c0ec60722e91e63ca114e68821c0c54a46549"
  end

  def install
    python_exe = Formula["python@3.11"].opt_libexec"binpython"
    args = %W[
      -GNinja
      -DBLAS=OpenBLAS
      -DBUILD_CUSTOM_PROTOBUF=OFF
      -DBUILD_PYTHON=ON
      -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      -DCMAKE_C_COMPILER=#{ENV.cc}
      -DPYTHON_EXECUTABLE=#{python_exe}
      -DUSE_CUDA=OFF
      -DUSE_DISTRIBUTED=ON
      -DUSE_METAL=OFF
      -DUSE_MKLDNN=OFF
      -DUSE_NNPACK=OFF
      -DUSE_OPENMP=ON
      -DUSE_SYSTEM_EIGEN_INSTALL=ON
      -DUSE_SYSTEM_PYBIND11=ON
    ]
    args << "-DUSE_MPS=ON" if OS.mac?

    ENV["LDFLAGS"] = "-L#{buildpath}buildlib"

    # Update references to shared libraries
    inreplace "torch__init__.py" do |s|
      s.sub!(here = os.path.abspath\(__file__\), "here = \"#{lib}\"")
      s.sub!("get_file_path('torch', 'bin', 'torch_shm_manager')", "\"#{bin}torch_shm_manager\"")
    end

    inreplace "torchutilscpp_extension.py", "_TORCH_PATH = os.path.dirname(os.path.dirname(_HERE))",
                                              "_TORCH_PATH = \"#{opt_prefix}\""

    system "cmake", "-B", "build", "-S", ".", *std_cmake_args, *args

    # Avoid references to Homebrew shims
    inreplace "buildcaffe2coremacros.h", Superenv.shims_pathENV.cxx, ENV.cxx

    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources
    venv.pip_install_and_link(buildpath, build_isolation: false)
  end

  test do
    # test that C++ libraries are available
    (testpath"test.cpp").write <<~EOS
      #include <torchtorch.h>
      #include <iostream>

      int main() {
        torch::Tensor tensor = torch::rand({2, 3});
        std::cout << tensor << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
                    "-I#{include}torchcsrcapiinclude",
                    "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10"
    system ".test"

    # test that the `torch` Python module is available
    system libexec"binpython", "-c", <<~EOS
      import torch
      t = torch.rand(5, 3)
      assert isinstance(t, torch.Tensor), "not a tensor"
      assert torch.distributed.is_available(), "torch.distributed is unavailable"
    EOS

    if OS.mac?
      # test that we have the MPS backend
      system libexec"binpython", "-c", <<~EOS
        import torch
        assert torch.backends.mps.is_built(), "MPS backend is not built"
      EOS
    end
  end
end