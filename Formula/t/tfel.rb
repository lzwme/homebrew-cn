class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https:thelfer.github.iotfelwebindex.html"
  url "https:github.comthelfertfelarchiverefstagsTFEL-4.2.2.tar.gz"
  sha256 "021864ad5b27ffce1915bcacc8f39f3e8a72ce6bd32e80a61ea0998a060180e5"
  license "GPL-1.0-or-later"
  head "https:github.comthelfertfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_sequoia: "eb3c990d66826a033f035a42388fda11fec4a99150ad8968bf30860f4226250c"
    sha256 arm64_sonoma:  "7ce9e584c8ce515d5e77d6d4bf2b16c5ac931d466fe7e84511772cf2088ae615"
    sha256 arm64_ventura: "2c53f68130a512a4824a035c7039dc41bc04f62e48c1d414c742c3c8b70d1611"
    sha256 sonoma:        "64dc30ffcb0a48c272163771393d8806aa11bea354e37a48d562d740af9c49d8"
    sha256 ventura:       "5e617f46cf41e2754ad018321a958ca55a4bba5e2c9ec528ae7cea1b2abd41a8"
    sha256 x86_64_linux:  "19e177ac60d4486a8b64bde342b9bfb697cb149693978513a6d57cc178da3994"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "boost-python3"
  depends_on "python@3.12"

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
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.mfront").write <<~EOS
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
    EOS
    system bin"mfront", "--obuild", "--interface=generic", "test.mfront"
    assert_predicate testpath"src"shared_library("libBehaviour"), :exist?
  end
end