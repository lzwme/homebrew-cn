class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http:www.opencoarrays.org"
  url "https:github.comsourceryinstituteOpenCoarraysreleasesdownload2.10.1OpenCoarrays-2.10.1.tar.gz"
  sha256 "b04b8fa724e7e4e5addbab68d81d701414e713ab915bafdf1597ec5dd9590cd4"
  license "BSD-3-Clause"
  revision 3
  head "https:github.comsourceryinstituteopencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ed611d58f8b731abca64c0af5ea8b32004958163ccc38f07aa9e7af4809fe74e"
    sha256 cellar: :any,                 arm64_ventura:  "62770dc7c4372e3916dc2954b9e7789522a30814d4a5ba6a668464cf8aac1451"
    sha256 cellar: :any,                 arm64_monterey: "9a0f57befe2f8d8693ee381f47af080af71dc31d599536ec412066d2ada892f2"
    sha256 cellar: :any,                 sonoma:         "3d6f991d961cb8cd57e420a660c1629809f02eef20cf531e1e5a1d5ef7ff0597"
    sha256 cellar: :any,                 ventura:        "b07e075bed22a99fba5e1863af072e3578368c431e8481eae607dc2f6c5daf1c"
    sha256 cellar: :any,                 monterey:       "959f6396ba12770f50e41861fb779e9fee5ce00f4a60d9dfaa527998fc4dad3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a149104f5a43c6759953519389650bcdf306ffe69be0db351cf7af8a482aeee8"
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