class Opencoarrays < Formula
  desc "Open-source coarray Fortran ABI, API, and compiler wrapper"
  homepage "http:www.opencoarrays.org"
  url "https:github.comsourceryinstituteOpenCoarraysreleasesdownload2.10.2OpenCoarrays-2.10.2.tar.gz"
  sha256 "e13f0dc54b966b0113deed7f407514d131990982ad0fe4dea6b986911d26890c"
  license "BSD-3-Clause"
  head "https:github.comsourceryinstituteopencoarrays.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dba684a4e77865917fc7c6c807012e2447fa8fe7fa45c9e60c91b47c5f4458f8"
    sha256 cellar: :any,                 arm64_ventura:  "a53da41941d47466668c858268044e104134f653701cc16ca881c19ab5f912df"
    sha256 cellar: :any,                 arm64_monterey: "664f1edb5fd95de835b5b3666474b1d338dd8deb209d9dd0d571302448a2d37c"
    sha256 cellar: :any,                 sonoma:         "f7c91bd8f62929dc873f962067afe86ac3873ad6aca43fc913159f944f1353a9"
    sha256 cellar: :any,                 ventura:        "16853aeb0cf2f8bc3f44ea4a6af93a6729aa0ddf83a4e2e7f19f0529539b699d"
    sha256 cellar: :any,                 monterey:       "090295d7492927e9582280cd41b571431bdd2f249c1711742d4852907cc53bb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42f9508fc3fd9b240a49175b105cd5adadd57b41ba9c2b82a928719241c13a87"
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