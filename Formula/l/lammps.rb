class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https:lammps.sandia.gov"
  url "https:github.comlammpslammpsarchiverefstagsstable_2Aug2023_update4.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20230802-update4"
  sha256 "6eed007cc24cda80b5dd43372b2ad4268b3982bb612669742c8c336b79137b5b"
  license "GPL-2.0-only"

  # The `strategy` block below is used to massage upstream tags into the
  # YYYY-MM-DD format we use in the `version`. This is necessary for livecheck
  # to be able to do proper `Version` comparison.
  livecheck do
    url :stable
    regex(^stable[._-](\d{1,2}\w+\d{2,4})(?:[._-](update\d*))?$i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        match = tag.match(regex)
        next if match.blank? || match[1].blank?

        date_str = Date.parse(match[1]).strftime("%Y%m%d")
        match[2].present? ? "#{date_str}-#{match[2]}" : date_str
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "65cac7b77ed988fba2bf6419e817dc8be8d3169fc8b4061146f5892e24bbcf13"
    sha256 cellar: :any,                 arm64_ventura:  "3ea046c63b46323fc05e0fb305a4c385190d116ab88f15fd2f97ebce506a5337"
    sha256 cellar: :any,                 arm64_monterey: "42b1a072e70010fa2fcf3f7ae5a118e1c472875692ed8fd7f70a409ab75abf2e"
    sha256 cellar: :any,                 sonoma:         "5febdee3a7edb1f5540d7348473d6ec64d7d9b7603a3beffbaefb1822e45600c"
    sha256 cellar: :any,                 ventura:        "1adf864b939dff6205cf07c69f4235f186b3063475e5077a9362c2ab9977b0b5"
    sha256 cellar: :any,                 monterey:       "28d5c0a2d1154172064da578408d5c70e7e5f393051ce01fdcb78515039a2044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fead648225541e280d4ff3365b2328a019a26ffca36c2f27ceb84529f4e003f1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "gcc" # for gfortran
  depends_on "jpeg-turbo"
  depends_on "kim-api"
  depends_on "libpng"
  depends_on "open-mpi"

  on_macos do
    depends_on "libomp"
  end

  def install
    %w[serial mpi].each do |variant|
      system "cmake", "-S", "cmake", "-B", "build_#{variant}",
                      "-C", "cmakepresetsall_on.cmake",
                      "-C", "cmakepresetsnolib.cmake",
                      "-DPKG_INTEL=no",
                      "-DPKG_KIM=yes",
                      "-DLAMMPS_MACHINE=#{variant}",
                      "-DBUILD_MPI=#{(variant == "mpi") ? "yes" : "no"}",
                      "-DBUILD_OMP=#{(variant == "serial") ? "no" : "yes"}",
                      "-DBUILD_SHARED_LIBS=yes",
                      "-DFFT=FFTW3",
                      "-DWITH_GZIP=yes",
                      "-DWITH_JPEG=yes",
                      "-DWITH_PNG=yes",
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      *std_cmake_args
      system "cmake", "--build", "build_#{variant}"
      system "cmake", "--install", "build_#{variant}"
    end

    pkgshare.install %w[doc tools bench examples]
  end

  test do
    system bin"lmp_serial", "-in", pkgshare"benchin.lj"
  end
end