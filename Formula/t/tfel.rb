class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://ghproxy.com/https://github.com/thelfer/tfel/archive/refs/tags/TFEL-4.1.0.tar.gz"
  sha256 "7505c41da9df5fb3c281651ff29b58a18fd4d91b92f839322f0267269c5f1375"
  license "GPL-1.0-or-later"
  revision 4
  head "https://github.com/thelfer/tfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_sonoma:   "edc729eb8e7b18b8efa57793e47ba554873313bc2d31a42688942f6cfd03665e"
    sha256 arm64_ventura:  "0f3e42d3d5b06a8c9b3b412b7702076d6a1af4ba05415311908adc10097084be"
    sha256 arm64_monterey: "fc14e32eecdb864f93135b543fb397167f8a849a001ebb2cb90e0cd75a747470"
    sha256 sonoma:         "6142c097b802858ab5db8d014b6f3de5eb2e849d26a80a36960361f2cfb6cb67"
    sha256 ventura:        "4a2e7d6a63a15d5398c17ceb30cfc119553d52e7fae93b8e0ccf584a00235534"
    sha256 monterey:       "8b551ff65eaeb53176a0e33e428a823251b54a97956d30d5112c73b40de911e0"
    sha256 x86_64_linux:   "c58bcf33f61a05d49debe3a934978fc37ff6c0fea4ae79b9680fc70561b0a9c7"
  end

  depends_on "cmake" => :build
  depends_on "gcc" => :build
  depends_on "boost-python3"
  depends_on "python@3.12"
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