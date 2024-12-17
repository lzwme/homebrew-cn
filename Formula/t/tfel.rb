class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https:thelfer.github.iotfelwebindex.html"
  url "https:github.comthelfertfelarchiverefstagsTFEL-4.2.2.tar.gz"
  sha256 "021864ad5b27ffce1915bcacc8f39f3e8a72ce6bd32e80a61ea0998a060180e5"
  license "GPL-1.0-or-later"
  revision 1
  head "https:github.comthelfertfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_sequoia: "23ca833616aa5ce341e1fa11c88cfb8353c87538d81942d2ea72d5cc942f97de"
    sha256 arm64_sonoma:  "68dff8e0e940ad1c90e035eb08bd11ff5c5dfddfd293e7b2b7c8a65991ae44a9"
    sha256 arm64_ventura: "c62435afb9b3d3da835a276f59c756500dc217cd53adf11e030f46ae12d18120"
    sha256 sonoma:        "b6ace891e47d3d17efc94bf788b5b2e90c738bc34e045643f607a82c917f0720"
    sha256 ventura:       "a3e3e86fd0f81654a04c77d96035c29ec8143ed6a5479b397d54e6b9c65f539c"
    sha256 x86_64_linux:  "33824b29b4cc77c2dcce4e0e3145b40da0b559cb65278982c8c9cdb2bf9f6693"
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