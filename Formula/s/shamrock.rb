class Shamrock < Formula
  desc "Astrophysical hydrodynamics using SYCL"
  homepage "https://github.com/Shamrock-code/Shamrock"
  url "https://ghfast.top/https://github.com/Shamrock-code/Shamrock/releases/download/v2025.05.0/shamrock-2025.05.0.tar"
  sha256 "59d5652467fd9453a65ae7b48e0c9b7d4162edc8df92e09d08dcc5275407a897"
  license "CECILL-2.1"
  revision 1
  head "https://github.com/Shamrock-code/Shamrock.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "6323f8da9268aff5d7ced2543cf89ebde8dc4cbc3dc50756fbebb71fa7945c1b"
    sha256 arm64_sequoia: "cf3a4a0ebb0bad131f091c5f8c458affe09b3643b7683aa67b705a97d34f83d7"
    sha256 arm64_sonoma:  "f891dda301e1f6f23a83c3decabd61df6ce73faae6e63552e4d058d26a212ba7"
    sha256 sonoma:        "0c497859d5a8ff3387f7b46fad164c270728e8d1a74d39592edb39edaeddb9db"
    sha256 arm64_linux:   "cc61abd988c7308020dc2ee2b60519a565267c9e93887ab414de98594e586618"
    sha256 x86_64_linux:  "0bcb52e22880d47fafddc933f6e279a2c016f0c907afe39d40b60b77d8cb9abb"
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