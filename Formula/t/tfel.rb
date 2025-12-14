class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://ghfast.top/https://github.com/thelfer/tfel/archive/refs/tags/TFEL-5.0.2.tar.gz"
  sha256 "3ba5ff8d369c15b38a56a1d33d489681ad2d2bb2ec93a67800bb5968cd1e89ec"
  license "GPL-1.0-or-later"
  head "https://github.com/thelfer/tfel.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "584926651518b45c9e17839c1f4ebe2e996130dd395eb3822387c3408663467c"
    sha256 arm64_sequoia: "cdca56ab20a8fdc7d11037574b73a8ff90948b45c7c31320515199dd77547568"
    sha256 arm64_sonoma:  "89728f5fb65b2d8404e9c0c2d6aa02cac573c8169699836c69052f3f7cebfdd4"
    sha256 sonoma:        "5ec9d1f0992f93d6d0249f40dfe1343d3449a01d11f5e66b6bf259b8e889302c"
    sha256 arm64_linux:   "d7e8b71b98a91a55d66ac0d3121bfb59fee92d9d876342c46cb39d83dccd4566"
    sha256 x86_64_linux:  "c703c5cb99254221e509bfb1e88dde41490944cd1ba4421147c50a3918b5cd0f"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "pybind11" => :build
  depends_on "python@3.14"

  # Fix to error: assignment of member in read-only object
  # PR ref: https://github.com/thelfer/tfel/pull/894
  patch do
    url "https://github.com/thelfer/tfel/commit/fb5ef740a47f2bef1b0d35b16b79a1fce7439ca9.patch?full_index=1"
    sha256 "bf5581c83529af35ac70687f9195f117c9a655aec3c06c1cea231707f15d4ede"
  end

  def install
    args = [
      "-DUSE_EXTERNAL_COMPILER_FLAGS=ON",
      "-Denable-reference-doc=OFF",
      "-Denable-website=OFF",
      "-Dlocal-castem-header=ON",
      "-Denable-python=ON",
      "-Denable-python-bindings=ON",
      "-Denable-pybind11=ON", # requires pybind11
      "-Denable-numpy-support=OFF",
      "-Denable-fortran=ON",
      "-Denable-cyrano=ON",
      "-Denable-lsdyna=ON",
      "-Denable-aster=ON",
      "-Denable-abaqus=ON",
      "-Denable-calculix=ON",
      "-Denable-comsol=ON",
      "-Denable-diana-fea=ON",
      "-Denable-ansys=ON",
      "-Denable-europlexus=ON",
      "-Denable-testing=OFF",
      "-Dpython-static-interpreter-workaround=ON",
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.mfront").write <<~MFRONT
      @Parser Implicit;
      @Behaviour Norton;
      @Algorithm NewtonRaphson_NumericalJacobian ;
      @RequireStiffnessTensor;
      @MaterialProperty real A;
      @MaterialProperty real m;
      @StateVariable real p ;
      @ComputeStress{
        sig = D*eel ;
      }
      @Integrator{
        real seq = sigmaeq(sig) ;
        Stensor n = Stensor(0.) ;
        if(seq > 1.e-12){
          n = 1.5*deviator(sig)/seq ;
        }
        feel += dp*n-deto ;
        fp -= dt*A*pow(seq,m) ;
      }
    MFRONT
    system bin/"mfront", "--obuild", "--interface=generic", "test.mfront"
    assert_path_exists testpath/"src"/shared_library("libBehaviour")
  end
end