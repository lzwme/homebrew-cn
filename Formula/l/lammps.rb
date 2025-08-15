class Lammps < Formula
  desc "Molecular Dynamics Simulator"
  homepage "https://docs.lammps.org/"
  url "https://ghfast.top/https://github.com/lammps/lammps/archive/refs/tags/stable_22Jul2025.tar.gz"
  # lammps releases are named after their release date. We transform it to
  # YYYY-MM-DD (year-month-day) so that we get a sane version numbering.
  # We only track stable releases as announced on the LAMMPS homepage.
  version "20250722"
  sha256 "38d7ab508433f33a53e11f0502aa0253945ce45d5595baf69665961c0a76da26"
  license "GPL-2.0-only"

  # The `strategy` block below is used to massage upstream tags into the
  # YYYY-MM-DD format we use in the `version`. This is necessary for livecheck
  # to be able to do proper `Version` comparison.
  livecheck do
    url :stable
    regex(/^stable[._-](\d{1,2}\w+\d{2,4})(?:[._-](update\d*))?$/i)
    strategy :git do |tags, regex|
      tags.map do |tag|
        match = tag.match(regex)
        next if match.blank? || match[1].blank?

        date_str = Date.parse(match[1]).strftime("%Y%m%d")
        match[2].present? ? "#{date_str}-#{match[2]}" : date_str
      end
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5dcbe62c226d2b98ebede1269ac9a31c1c1a5846f58d678e37061846ba0cba67"
    sha256 cellar: :any,                 arm64_sonoma:  "dd3a100bb7068a71b8dfaf28e492a3ce20c227f2f9e0644b94f6d4f899ed99cf"
    sha256 cellar: :any,                 arm64_ventura: "9928dabf3feeecf5d8203d596d566d391f10c5a9b420e18360c88c3b0092fde4"
    sha256 cellar: :any,                 sonoma:        "71e66176a276d78240fee653eb06df98e95624e1d7abdedb1f303b81d822ab51"
    sha256 cellar: :any,                 ventura:       "ff8e8db48554205827c9a973b98eec0081968ce2ffb6624719f509633aa5a86b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "491186c7e5217a82b045d031bca445dfdb0db940e75fd4285890565f249c91c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0721f7b5637369e7fc3677f0f0e4dd66ef06c8bc1c81a1b938c796cf2ddf527d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "voro++" => :build

  depends_on "fftw"
  depends_on "jpeg-turbo"
  depends_on "kim-api"
  depends_on "libpng"
  depends_on "open-mpi"

  uses_from_macos "curl"
  uses_from_macos "python"

  on_macos do
    depends_on "libomp"
  end

  def install
    %w[serial mpi].each do |variant|
      args = [
        "-S", "cmake", "-B", "build_#{variant}",
        "-C", "cmake/presets/all_on.cmake",
        "-C", "cmake/presets/nolib.cmake",
        "-DPKG_INTEL=no",
        "-DPKG_KIM=yes",
        "-DPKG_VORONOI=yes",
        "-DLAMMPS_MACHINE=#{variant}",
        "-DBUILD_MPI=#{(variant == "mpi") ? "yes" : "no"}",
        "-DBUILD_OMP=#{(variant == "serial") ? "no" : "yes"}",
        "-DBUILD_SHARED_LIBS=yes",
        "-DFFT=FFTW3",
        "-DWITH_GZIP=yes",
        "-DWITH_JPEG=yes",
        "-DWITH_PNG=yes",
        "-DCMAKE_INSTALL_RPATH=#{rpath}"
      ]
      args << "-DOpenMP_CXX_FLAGS=-I#{Formula["libomp"].opt_include}" if OS.mac?
      system "cmake", *args, *std_cmake_args
      system "cmake", "--build", "build_#{variant}"
      system "cmake", "--install", "build_#{variant}"
    end

    pkgshare.install %w[doc tools bench examples]
  end

  test do
    system bin/"lmp_serial", "-in", pkgshare/"bench/in.lj"
    output = shell_output("#{bin}/lmp_serial -h")
    %w[KSPACE POEMS VORONOI].each do |pkg|
      assert_match pkg, output
    end
  end
end