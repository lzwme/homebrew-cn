class JsonFortran < Formula
  desc "Fortran 2008 JSON API"
  homepage "https://github.com/jacobwilliams/json-fortran"
  url "https://ghfast.top/https://github.com/jacobwilliams/json-fortran/archive/refs/tags/9.1.0.tar.gz"
  sha256 "20aa9f9d0af5469c8305a79acdabd5482a417516259b28113432e79626d648ec"
  license "BSD-3-Clause"
  head "https://github.com/jacobwilliams/json-fortran.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a6c47be708e0e06e29694f025f7c5bb98778bec76cd6279a5a6162133212335a"
    sha256 cellar: :any,                 arm64_sequoia: "ca9dd223cf47ee9f5e9ff9df181bca1bf816bcfe0343cc990d1d1b6788c12b97"
    sha256 cellar: :any,                 arm64_sonoma:  "9f9e1aefbbfad9e722ad2b027494b1682b47fe879a400cfdc4f633c73dc09760"
    sha256 cellar: :any,                 sonoma:        "f4decc76b0608c982c9ffbd185e964556b09c6bb2741503a76925edb232f4908"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da312fff3991993ee95b8b61067154402e845839e98ddbdd08e0b6a81f7cbff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ca5565cbc2a7cfa5e4a7db44eaa004e14a7d57a087acbd8d6f3f4503a2d1fb8"
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