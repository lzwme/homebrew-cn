class Shamrock < Formula
  desc "Astrophysical hydrodynamics using SYCL"
  homepage "https://github.com/Shamrock-code/Shamrock"
  url "https://ghfast.top/https://github.com/Shamrock-code/Shamrock/releases/download/v2025.10.0/shamrock-2025.10.0.tar"
  sha256 "72683352d862d7b3d39568151a17ea78633bd4976a40eacb77098d3ef0ca3c55"
  license "CECILL-2.1"
  head "https://github.com/Shamrock-code/Shamrock.git", branch: "main"

  bottle do
    sha256 arm64_tahoe:   "7c1186e99fc8c0f9a7a3d24ad1a567af9d51ea1d21ef1388061176c1835c3846"
    sha256 arm64_sequoia: "7d9a8431163d090cb87f372c902668d6ad63c10b59007649c08bab964537927e"
    sha256 arm64_sonoma:  "7cb215b578f001046d215348af3e62be75c4c54e934cb4e1f77d0297fe0384e7"
    sha256 sonoma:        "aa62daa6853bf1198dc5798050c244f3e46fff90263191c6a7711f3b90d2f366"
    sha256 arm64_linux:   "beac32843e9741cdb0b49c9eeff5596e839529bd72d41e15a9d2590120346437"
    sha256 x86_64_linux:  "147df51883fc38480ad75d1c4ae774a6d65b4fcaf301c4cbae61ca2b65fc2af9"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on "pybind11" => :build
  depends_on "adaptivecpp"
  depends_on "boost"
  depends_on "open-mpi"
  depends_on "python@3.14"

  on_macos do
    depends_on "libomp"
  end

  def python
    which("python3.14")
  end

  def site_packages(python)
    prefix/Language::Python.site_packages(python)
  end

  def install
    rm_r(%w[
      external/fmt
      external/nlohmann_json
      external/pybind11
    ])

    args = %W[
      -DSHAMROCK_ENABLE_BACKEND=SYCL
      -DPYTHON_EXECUTABLE=#{python}
      -DSYCL_IMPLEMENTATION=ACPPDirect
      -DCMAKE_CXX_COMPILER=acpp
      -DACPP_PATH=#{Formula["adaptivecpp"].opt_prefix}
      -DSHAMROCK_EXTERNAL_FMTLIB=ON
      -DSHAMROCK_EXTERNAL_JSON=ON
      -DSHAMROCK_EXTERNAL_PYBIND11=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    py_package = site_packages(python).join("shamrock")

    mkdir_p py_package
    cp_r Dir["build/*.so"], py_package

    (py_package/"__init__.py").write <<~PY
      from .shamrock import *
    PY
  end

  test do
    system bin/"shamrock", "--help"
    system bin/"shamrock", "--smi"
    system "mpirun", "-n", "1", bin/"shamrock", "--smi", "--sycl-cfg", "auto:OpenMP"
    (testpath/"test.py").write <<~PY
      import shamrock
      shamrock.change_loglevel(125)
      shamrock.sys.init('0:0')
      shamrock.sys.close()
    PY
    system python, testpath/"test.py"
  end
end