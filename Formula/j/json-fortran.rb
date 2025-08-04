class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://ghfast.top/https://github.com/jacobwilliams/json-fortran/archive/refs/tags/9.0.4.tar.gz"
  sha256 "af5669697b9f63329821e28f88ec92e165c54f6f278cd122e0ed28e90faeb0eb"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b01f1f424c8e5a7005028ac66cebe775f2c775e11db8ff9a43dfca6be3f604f9"
    sha256 cellar: :any,                 arm64_sonoma:  "c0222c4adb85f6615879f53f355463c0acbbd71a5a8ae7bef417c4d327d90c82"
    sha256 cellar: :any,                 arm64_ventura: "5adef73c4ebf93a98b0ae35807f10838298bcd7472a8f619d211f1fb23ec8392"
    sha256 cellar: :any,                 sonoma:        "4960a71a146461e366b1b2e8de9e43ffa4d053c31248f58e803424438c0e980e"
    sha256 cellar: :any,                 ventura:       "6c0aef2ca746201c409ee26ab5c08e51b8f730ea3adae22d268a4ed0d2b9474e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e68e4932081b0f4b8ad098e5573cddf5536a1527f103be154810eefff0c41b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a06d8236d1a217a88391630958bc8d99201184bb67e379b6ed844b31e974d3c"
  end

  depends_on "cmake" => :build
  depends_on "ford" => :build
  depends_on "gcc" # for gfortran

  def install
    args = %w[
      -DUSE_GNU_INSTALL_CONVENTION:BOOL=TRUE
      -DENABLE_UNICODE:BOOL=TRUE
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"json_test.f90").write <<~FORTRAN
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
    FORTRAN
    ENV.prepend_path "PATH", Formula["binutils"].opt_bin if OS.linux?
    system "gfortran", "-o", "test", "json_test.f90", "-I#{include}",
                       "-L#{lib}", "-ljsonfortran"
    system "./test"
  end
end