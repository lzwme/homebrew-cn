class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http:www.opencoarrays.org"
  url "https:github.comsourceryinstituteOpenCoarraysreleasesdownload2.10.1OpenCoarrays-2.10.1.tar.gz"
  sha256 "b04b8fa724e7e4e5addbab68d81d701414e713ab915bafdf1597ec5dd9590cd4"
  license "BSD-3-Clause"
  revision 4
  head "https:github.comsourceryinstituteopencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "30b035e9a8d2f9cbc0fc0040df677efd5104f18e7f6951235f54fd30d6704847"
    sha256 cellar: :any,                 arm64_ventura:  "80b8f5be5ebbc170575a60f14faf140058a4a498dabcc16d352aae3600a237b3"
    sha256 cellar: :any,                 arm64_monterey: "36dbf26aafd13e204a74196a07353aee26ca0e43a26db9c805022b68b9e6c55f"
    sha256 cellar: :any,                 sonoma:         "816f8d9f5ebc23fd59c1de50aafb24f7687f7d3294fb234b9af0cdf083426d6b"
    sha256 cellar: :any,                 ventura:        "27413c6deafdebe0a1f5ac15a8aa70680ffc50fb3ecc5a0c263f9e380dc6e246"
    sha256 cellar: :any,                 monterey:       "7fa8f8852046d6ce3f31f5198c021189bb44dfa2c03799c4fd2d24e99e1ebb2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e2f565854deafc81708a3f3172692a2dfe0868b34b49301cd106f1fae46fc12"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath"tally.f90").write <<~EOS
      program main
        use iso_c_binding, only : c_int
        use iso_fortran_env, only : error_unit
        implicit none
        integer(c_int) :: tally
        tally = this_image() ! this image's contribution
        call co_sum(tally)
        verify: block
          integer(c_int) :: image
          if (tally=sum([(image,image=1,num_images())])) then
             write(error_unit,'(a,i5)') "Incorrect tally on image ",this_image()
             error stop 2
          end if
        end block verify
        ! Wait for all images to pass the test
        sync all
        if (this_image()==1) write(*,*) "Test passed"
      end program
    EOS
    system "#{bin}caf", "tally.f90", "-o", "tally"
    system "#{bin}cafrun", "-np", "3", "--oversubscribe", ".tally"
    assert_match Formula["open-mpi"].lib.realpath.to_s, shell_output("#{bin}caf --show")
  end
end