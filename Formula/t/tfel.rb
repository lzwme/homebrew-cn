class Tfel < Formula
  desc "Code generation tool dedicated to material knowledge for numerical mechanics"
  homepage "https://thelfer.github.io/tfel/web/index.html"
  url "https://ghproxy.com/https://github.com/thelfer/tfel/archive/refs/tags/TFEL-4.1.1.tar.gz"
  sha256 "e0f229094e88a2d6c6a78ae60fa77d2f4b8294e9d810c21fd7df61004bf29a33"
  license "GPL-1.0-or-later"
  head "https://github.com/thelfer/tfel.git", using: :git, branch: "master"

  bottle do
    sha256 arm64_sonoma:   "10722376b4cbe9b0ab7b9030823d4931c65c9b769513305d2a5b4bc12a5f5d42"
    sha256 arm64_ventura:  "919da43d6e792be25d0f1f5bc2c841ee1217faa47f09bcc98dee2a75ce6111c0"
    sha256 arm64_monterey: "007ddd0f47c41766f491403073f20abb1a8e3dba03240a3cfdb11b74482f6b17"
    sha256 sonoma:         "ff36a7315f89c580016d8da3e610c249144d83d100072ef48adf3ab1c1e5ca96"
    sha256 ventura:        "dd241f73800b74b20e5e1426b8c75b48fe45509cfb7234fd1a1bcce829c7d1de"
    sha256 monterey:       "2e0f309b16ce65373b647eb9767634e13b8b91855939066b43f4f36f9aecc274"
    sha256 x86_64_linux:   "7b51d327a3d6c2c14a2fc2d82fae30d237918edfc6c3867af2930f95ff355132"
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