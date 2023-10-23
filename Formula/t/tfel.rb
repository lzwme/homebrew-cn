class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://ghproxy.com/https://github.com/thelfer/tfel/archive/refs/tags/TFEL-4.1.0.tar.gz"
  sha256 "7505c41da9df5fb3c281651ff29b58a18fd4d91b92f839322f0267269c5f1375"
  license "GPL-1.0-or-later"
  revision 3
  head "https://github.com/thelfer/tfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_sonoma:   "d0d0249365f4257ac0305d28b1feb4ddec767a531fa9e35039bbc2566c4cc6f9"
    sha256 arm64_ventura:  "df01dc4668e066acfbe5f8126e51732e64078456f31c9a9b5a3c44df119558fb"
    sha256 arm64_monterey: "a863dc8f6c489c495e445e77c44e70d00f5e592091d106067f647a288a53bb4c"
    sha256 sonoma:         "1b549b313281caff2777ff81fd954776486df50d1f939c5a9b28797110a40099"
    sha256 ventura:        "d7a7b725ffd3d5159b0039076b910dfda41d8ac18e5508257a67113b9ead0ebe"
    sha256 monterey:       "338749c2eeb93a7e042213a7f6c7136f22f6a706fcb9713e3db585169814a0ae"
    sha256 x86_64_linux:   "2ec823e88281a20344276930bbbfa1c6529ab81be54a2f458fee2054b7a7afae"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "boost-python3"
  depends_on "python@3.11"
  fails_with gcc: "5"

  def install
    args = [
      "-DUSE_EXTERNAL_COMPILER_FLAGS=ON",
      "-Denable-reference-doc=OFF",
      "-Denable-website=OFF",
      "-Dlocal-castem-header=ON",
      "-Denable-python=ON",
      "-Denable-python-bindings=ON",  # requires boost-python
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
    (testpath/"test.mfront").write <<~EOS
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
    EOS
    system bin/"mfront", "--obuild", "--interface=generic", "test.mfront"
    assert_predicate testpath/"src"/shared_library("libBehaviour"), :exist?
  end
end