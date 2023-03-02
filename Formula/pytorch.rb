class Pytorch < Formula
  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch.git",
      tag:      "v1.13.1",
      revision: "49444c3e546bf240bed24a101e747422d1f8a0ee"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5139d39a8bc2e721af73787687fd57e2f39017960191f22de88038f4820bdd55"
    sha256 cellar: :any,                 arm64_monterey: "7b04d178d047d55137f46cc164b47901699fcde6357b74f03334d02dc44d8c5a"
    sha256 cellar: :any,                 arm64_big_sur:  "a29db0d739aa9849fbc4857b2847d1bc2e037fad7ac6fbfeae2a988d5f0d28ab"
    sha256 cellar: :any,                 ventura:        "029a733db1b0c93e777abeca9f52c36727173d02be6b5d74e00c382566c47141"
    sha256 cellar: :any,                 monterey:       "1a31ca6185596ee605c15ecfe00e2511c6e0391043905ca92b134cb0b07da1e6"
    sha256 cellar: :any,                 big_sur:        "31cfa153c51968a39140ff49dc9944b3c6c86d7bcc6ba17b53cb0fc74cc1c8ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f176777a132f2a4130808106f812d620694cd89b5ee49036f8826a9eeba4bbff"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "eigen"
  depends_on "libuv"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "pybind11"
  depends_on "python-typing-extensions"
  depends_on "pyyaml"

  on_macos do
    depends_on "libomp"
  end

  def install
    openssl_root = Formula["openssl@1.1"].opt_prefix
    python_exe = Formula["python@3.11"].opt_libexec/"bin/python"
    args = %W[
      -GNinja
      -DBLAS=OpenBLAS
      -DBUILD_CUSTOM_PROTOBUF=OFF
      -DBUILD_PYTHON=ON
      -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      -DCMAKE_C_COMPILER=#{ENV.cc}
      -DOPENSSL_ROOT_DIR=#{openssl_root}
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
    # Remove when https://github.com/pytorch/pytorch/issues/67974 is addressed
    args << "-DUSE_SYSTEM_BIND11=ON"

    ENV["LDFLAGS"] = "-L#{buildpath}/build/lib"

    # Update references to shared libraries
    inreplace "torch/__init__.py" do |s|
      s.sub!(/here = os.path.abspath\(__file__\)/, "here = \"#{lib}\"")
      s.sub!(/get_file_path\('torch', 'bin', 'torch_shm_manager'\)/, "\"#{bin}/torch_shm_manager\"")
    end

    inreplace "torch/utils/cpp_extension.py", "_TORCH_PATH = os.path.dirname(os.path.dirname(_HERE))",
                                              "_TORCH_PATH = \"#{opt_prefix}\""

    system "cmake", "-B", "build", "-S", ".", *std_cmake_args, *args

    # Avoid references to Homebrew shims
    inreplace "build/caffe2/core/macros.h", Superenv.shims_path/ENV.cxx, ENV.cxx

    system python_exe, *Language::Python.setup_install_args(prefix, python_exe)
  end

  test do
    # test that C++ libraries are available
    (testpath/"test.cpp").write <<~EOS
      #include <torch/torch.h>
      #include <iostream>

      int main() {
        torch::Tensor tensor = torch::rand({2, 3});
        std::cout << tensor << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{include}/torch/csrc/api/include",
                    "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10"
    system "./test"

    # test that `torch` Python module is available
    python = Formula["python@3.11"]
    system python.opt_libexec/"bin/python", "-c", <<~EOS
      import torch
      torch.rand(5, 3)
    EOS
  end
end