class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https:github.comjacobwilliamsjson-fortran"
  url "https:github.comjacobwilliamsjson-fortranarchiverefstags8.5.2.tar.gz"
  sha256 "ba7243ab28d4d06c5d0baef27dab0041cee0f050dea9ec3a854a03f4e3e9667a"
  license "BSD-3-Clause"
  head "https:github.comjacobwilliamsjson-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "be1d61841e02f245d7c867cc0a029c86af7b030c1721ccd010de5cae04c46c52"
    sha256 cellar: :any,                 arm64_ventura:  "f1d1bdadbd0590b680b1a22e6c6594cd9753a7e05a86cc18fe8c629ff11ce433"
    sha256 cellar: :any,                 arm64_monterey: "15cca7c529d210e8af02931b4ba3c2a9a824b497148c8931be90da12a653c494"
    sha256 cellar: :any,                 sonoma:         "97dfcaa6ee1b2001658f77fbeda7768a6878b1f8c8201c8c4994a80559286718"
    sha256 cellar: :any,                 ventura:        "fcca63f10d6f6e6110510829aaba16ee4dd0864264081ec69e18c463ac9262ba"
    sha256 cellar: :any,                 monterey:       "3de419613a2230e883f8e5620ffc98cc548370d6097b991b969c1abe3d909b53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d57e158c6d29f3b2095e199f37b2b6c70faf2d745bfdbccdd5ce6109e3ff900b"
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