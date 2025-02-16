class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https:thelfer.github.iotfelwebindex.html"
  url "https:github.comthelfertfelarchiverefstagsTFEL-4.2.2.tar.gz"
  sha256 "021864ad5b27ffce1915bcacc8f39f3e8a72ce6bd32e80a61ea0998a060180e5"
  license "GPL-1.0-or-later"
  revision 2
  head "https:github.comthelfertfel.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "51bcb05474db6dbc83b46a31d58c041a3b0f62eaa337cd54a5792654d5fa7040"
    sha256 arm64_sonoma:  "b64b19003aa0a2455bbdf1da89226b7b6507518501ffce59e122929c9375557d"
    sha256 arm64_ventura: "88ab880674337b0af62a452d4a817cc53556f59b65619e6217e581108894450c"
    sha256 sonoma:        "082209d55113110e980075de67480022bcdb34bf483b1130217d15bc4f6487e0"
    sha256 ventura:       "54ab0c599adba2e9dcbf46c4d31e8775cbe5b8cc968079f6ddaa3fd082198a2b"
    sha256 x86_64_linux:  "5ec48c46e25bcf9c403d2639de829bfc3eaac60e734c5311ca42e4b8f50bc089"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build # for gfortran
  depends_on "boost-python3"
  depends_on "python@3.13"

  def install
    args = [
      "-DUSE_EXTERNAL_COMPILER_FLAGS=ON",
      "-Denable-reference-doc=OFF",
      "-Denable-website=OFF",
      "-Dlocal-castem-header=ON",
      "-Denable-python=ON",
      "-Denable-python-bindings=ON", # requires boost-python
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
      "-Dpython-static-interpreter-workaround=ON",
    ]
    # Avoid linkage to boost container and graph modules
    # Issue ref: https:github.comboostorgboostissues985
    args << "-DCMAKE_MODULE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.mfront").write <<~MFRONT
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
          n = 1.5*deviator(sig)seq ;
        }
        feel += dp*n-deto ;
        fp -= dt*A*pow(seq,m) ;
      }
    MFRONT
    system bin"mfront", "--obuild", "--interface=generic", "test.mfront"
    assert_path_exists testpath"src"shared_library("libBehaviour")
  end
end