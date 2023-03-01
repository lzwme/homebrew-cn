class Otf2 < Formula
  desc "Open Trace Format 2 file handling library"
  homepage "https://www.vi-hps.org/projects/score-p/"
  url "https://perftools.pages.jsc.fz-juelich.de/cicd/otf2/tags/otf2-3.0.2/otf2-3.0.2.tar.gz", using: :homebrew_curl
  sha256 "ae3a7ad83055d8f873738fee5031470652d31b9bcbf223dd556aea41f5f62303"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?otf2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0e81939c9d785d6bb311495275795138c6f7c93e4964519b7c24c547d27ec29c"
    sha256 arm64_monterey: "e5fffba2265304195226eb70368ce45ac5344ded0db9e3ec4ef2da8d6f882cac"
    sha256 arm64_big_sur:  "4476aae927b41d23196fc37bb42b915e75676cc0adec356c50a925151ce1c35d"
    sha256 ventura:        "48b0c402498bad68d9a41556d6a83f4c7412327f320d7383a42a71c15cfb257f"
    sha256 monterey:       "4f677ed96138f801ccb4298d91e5e708b37b8b74d9ac282088f47933c9d6b155"
    sha256 big_sur:        "3b452ecba67d54fe3a178ce9250d96b30007f51a39fc44f249784cb29144bfe1"
    sha256 x86_64_linux:   "8595efc2302f6733b74a9938abb81f1d69dc184714a3689089b9a5e9dd9fe84d"
  end

  depends_on "sphinx-doc" => :build
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "python@3.11"
  depends_on "six"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "build-frontend"
  end
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    directory "build-backend"
  end

  def install
    ENV["PYTHON"] = which("python3.11")
    ENV["SPHINX"] = Formula["sphinx-doc"].opt_bin/"sphinx-build"

    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"

    inreplace pkgshare/"otf2.summary", "#{Superenv.shims_path}/", ""
  end

  test do
    cp_r share/"doc/otf2/examples", testpath
    workdir = testpath/"examples"
    chdir "#{testpath}/examples" do
      # Use -std=gnu99 to work around Linux error when compiling with -std=c99, which
      # requires _POSIX_C_SOURCE >= 199309L in order to use POSIX time functions/macros.
      inreplace "Makefile", "-std=c99", "-std=gnu99" if OS.linux?
      # build serial tests
      system "make", "serial", "mpi", "pthread"
      %w[
        otf2_mpi_reader_example
        otf2_mpi_reader_example_cc
        otf2_mpi_writer_example
        otf2_pthread_writer_example
        otf2_reader_example
        otf2_writer_example
      ].each { |p| assert_predicate workdir/p, :exist? }
      system "./otf2_writer_example"
      assert_predicate workdir/"ArchivePath/ArchiveName.otf2", :exist?
      system "./otf2_reader_example"
      rm_rf "./ArchivePath"
      system Formula["open-mpi"].opt_bin/"mpirun", "-n", "2", "./otf2_mpi_writer_example"
      assert_predicate workdir/"ArchivePath/ArchiveName.otf2", :exist?
      2.times do |n|
        assert_predicate workdir/"ArchivePath/ArchiveName/#{n}.evt", :exist?
      end
      system Formula["open-mpi"].opt_bin/"mpirun", "-n", "2", "./otf2_mpi_reader_example"
      system "./otf2_reader_example"
      rm_rf "./ArchivePath"
      system "./otf2_pthread_writer_example"
      assert_predicate workdir/"ArchivePath/ArchiveName.otf2", :exist?
      system "./otf2_reader_example"
    end
  end
end