class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https:github.comjacobwilliamsjson-fortran"
  url "https:github.comjacobwilliamsjson-fortranarchiverefstags8.5.1.tar.gz"
  sha256 "07fb1afb72b17eac3a89724ac77523de2247c0625843fb559738168ee08ebf18"
  license "BSD-3-Clause"
  head "https:github.comjacobwilliamsjson-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1b6b02059833fcd411e2c4d52d0e548687202661d35817acac2ac3e0e1f9c5e5"
    sha256 cellar: :any,                 arm64_ventura:  "2d8166ab4e85dab55413bb9f89e409834757c371b4c1c111722b141ae4046642"
    sha256 cellar: :any,                 arm64_monterey: "1a47455132bc29cbe40467274c839e6afeb8e55a09fe1a47fdaf387dd7580890"
    sha256 cellar: :any,                 sonoma:         "92e3f18f2cef51914109b2e1aadb988cc6c9a0c04934ce7e819c1ce4c31a72f2"
    sha256 cellar: :any,                 ventura:        "bd7f2212cc1f4a4a88ce668b8097fbc6a8e41c8ab0c513a0fd3bd0e28e8ab069"
    sha256 cellar: :any,                 monterey:       "d9053ef10264a7984a68aaa11e74d332e21bc2c691f9977416e6b77a0800905d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d6160e89514b7cacd97cffef3c69979e78596c01a1f8811b180194a4b846a6c"
  end

  depends_on "cmake" => :build
  depends_on "ford" => :build
  depends_on "gcc" # for gfortran

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE",
                            "-DENABLE_UNICODE:BOOL=TRUE"
      system "make", "install"
    end
  end

  test do
    (testpath"json_test.f90").write <<~EOS
      program example
      use json_module, RK => json_RK
      use iso_fortran_env, only: stdout => output_unit
      implicit none
      type(json_core) :: json
      type(json_value),pointer :: p, inp
      call json%initialize()
      call json%create_object(p,'')
      call json%create_object(inp,'inputs')
      call json%add(p, inp)
      call json%add(inp, 't0', 0.1_RK)
      call json%print(p,stdout)
      call json%destroy(p)
      if (json%failed()) error stop 'error'
      end program example
    EOS
    system "gfortran", "-o", "test", "json_test.f90", "-I#{include}",
                       "-L#{lib}", "-ljsonfortran"
    system ".test"
  end
end