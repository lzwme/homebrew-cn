class Otf2 < Formula
  desc "Open Trace Format 2 file handling library"
  homepage "https:www.vi-hps.orgprojectsscore-p"
  url "https:perftools.pages.jsc.fz-juelich.decicdotf2tagsotf2-3.0.3otf2-3.0.3.tar.gz", using: :homebrew_curl
  sha256 "18a3905f7917340387e3edc8e5766f31ab1af41f4ecc5665da6c769ca21c4ee8"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(href=.*?otf2[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sonoma:   "2de301b69c4060b455bb0aab6f75d44aafe120408aada229252574dd7d58175c"
    sha256 arm64_ventura:  "9b2a09caa4efd128380e4b5d870878754aa4ada4205494c138bccec60dac635a"
    sha256 arm64_monterey: "ab5062bed5e22479fb0f1e9509fc4bf81b15f90f4df39184cf31e9f4d13b116f"
    sha256 arm64_big_sur:  "11ec92983795ffaa61edda9c9199d36a945313dec3d8a530859245f235959d28"
    sha256 sonoma:         "7b5963fa223289591e56b84ad30c2994ffdab36d6f8e73343b15eaa58eb61cae"
    sha256 ventura:        "2edda30befcbcb77def5d9fac6276efd42e232f48110d4b126f8683071333d21"
    sha256 monterey:       "b45008e32dd91aadf228147e790db44b28fbf3d6ffff5b352a1e9cdf1f2bf738"
    sha256 big_sur:        "91a62f5bd3d8498cd703a7a2470d06bf4d0eb64e56de59aa0a5e50b40b2d2af3"
    sha256 x86_64_linux:   "c0cf9c4054eca7d9c45aa5adce3579532ea373b02afff6d664420c2fc83d06cf"
  end

  depends_on "sphinx-doc" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "python@3.11"
  depends_on "six"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "build-frontend"
  end
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patches03cf8088210822aa2c1ab544ed58ea04c897d9c4libtoolconfigure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "build-backend"
  end

  def install
    ENV["PYTHON"] = which("python3.11")
    ENV["SPHINX"] = Formula["sphinx-doc"].opt_bin"sphinx-build"

    system ".configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"

    inreplace pkgshare"otf2.summary", "#{Superenv.shims_path}", ""
  end

  test do
    cp_r share"docotf2examples", testpath
    workdir = testpath"examples"
    chdir "#{testpath}examples" do
      # build serial tests
      system "make", "serial", "mpi", "pthread"
      %w[
        otf2_mpi_reader_example
        otf2_mpi_reader_example_cc
        otf2_mpi_writer_example
        otf2_pthread_writer_example
        otf2_reader_example
        otf2_writer_example
      ].each { |p| assert_predicate workdirp, :exist? }
      system ".otf2_writer_example"
      assert_predicate workdir"ArchivePathArchiveName.otf2", :exist?
      system ".otf2_reader_example"
      rm_rf ".ArchivePath"
      system Formula["open-mpi"].opt_bin"mpirun", "-n", "2", ".otf2_mpi_writer_example"
      assert_predicate workdir"ArchivePathArchiveName.otf2", :exist?
      2.times do |n|
        assert_predicate workdir"ArchivePathArchiveName#{n}.evt", :exist?
      end
      system Formula["open-mpi"].opt_bin"mpirun", "-n", "2", ".otf2_mpi_reader_example"
      system ".otf2_reader_example"
      rm_rf ".ArchivePath"
      system ".otf2_pthread_writer_example"
      assert_predicate workdir"ArchivePathArchiveName.otf2", :exist?
      system ".otf2_reader_example"
    end
  end
end