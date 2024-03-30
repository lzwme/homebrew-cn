class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http:www.opencoarrays.org"
  url "https:github.comsourceryinstituteOpenCoarraysreleasesdownload2.10.2OpenCoarrays-2.10.2.tar.gz"
  sha256 "e13f0dc54b966b0113deed7f407514d131990982ad0fe4dea6b986911d26890c"
  license "BSD-3-Clause"
  revision 2
  head "https:github.comsourceryinstituteopencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9e541ae1a9d4233a8ea34a7078b57f2d9bda43588f83f1e3727c19bfd7a4ca85"
    sha256 cellar: :any,                 arm64_ventura:  "e8ec2e14d750258735ab6f37f356cfb3173ea8e335babeca9219d3381fa9378f"
    sha256 cellar: :any,                 arm64_monterey: "0c91af81c400a5b28cd9b5c67b25dc370ecc9960bb3342d751bbff4fe12fc22d"
    sha256 cellar: :any,                 sonoma:         "608f5a35d6c88b2348fc17a3ad4a54552c79a7a6b6fc75e99978b8b2cf9b69d6"
    sha256 cellar: :any,                 ventura:        "21622de2a3f88ecc8e691ec3aae354e6d40cd49079162aeb836f1ff0afa3e0a3"
    sha256 cellar: :any,                 monterey:       "df33bcabd1d86269d4790038ea34bbfa45f6d6b0ba7a3fd8dc67f7594b768397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6068295f11046f6a146e30c323c83ff9f3153b18cae1c00782ad03ebde9a027"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "open-mpi"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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