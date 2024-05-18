class OpenMpi < Formula
  desc "High performance message passing library"
  homepage "https:www.open-mpi.org"
  url "https:download.open-mpi.orgreleaseopen-mpiv5.0openmpi-5.0.3.tar.bz2"
  sha256 "990582f206b3ab32e938aa31bbf07c639368e4405dca196fabe7f0f76eeda90b"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :homepage
    regex(MPI v?(\d+(?:\.\d+)+) releasei)
  end

  bottle do
    sha256 arm64_sonoma:   "2eb8af01260123ac14e6c47dc0c2d6533ae846b93805e95940fd991af286b228"
    sha256 arm64_ventura:  "41fbd96be69b9cd6f06f29acb9e29d7f182af84ee9a35ccb2b60b3fea526cbea"
    sha256 arm64_monterey: "e62156754013d4acf586032f28da661f0ff0275a664347a77a616ac76dede707"
    sha256 sonoma:         "963cccb887f66a3da95feb19098e65309c46219491cb080d0bf864ea45e7fcdc"
    sha256 ventura:        "ee9132e624c3e74d153362aedac38bc327937ca8c99e45aea4e19a7c188aade1"
    sha256 monterey:       "d3e7aa52538f37cfae1da06cdf23d04bdfe29fc9e3c9c6ad7c8c4cf2c2f6523e"
    sha256 x86_64_linux:   "96f0736d212d804309eebd055632619b99242e895e195013be2b01ba742fa798"
  end

  head do
    url "https:github.comopen-mpiompi.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gcc" # for gfortran
  depends_on "hwloc"
  depends_on "libevent"
  depends_on "pmix"

  conflicts_with "mpich", because: "both install MPI compiler wrappers"

  def install
    if OS.mac?
      # Otherwise libmpi_usempi_ignore_tkr gets built as a static library
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version

      # Work around asm incompatibility with new linker (FB13194320)
      # https:github.comopen-mpiompiissues12427
      ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500
    end

    # Avoid references to the Homebrew shims directory
    inreplace_files = %w[
      ompitoolsompi_infoparam.c
      oshmemtoolsoshmem_infoparam.c
    ]
    inreplace_files_cc = %w[
      3rd-partyopenpmixsrctoolspmix_infosupport.c
      3rd-partyprrtesrctoolsprte_infoparam.c
    ]

    cxx = OS.linux? ? "g++" : ENV.cxx
    inreplace inreplace_files, "OMPI_CXX_ABSOLUTE", "\"#{cxx}\""

    cc = OS.linux? ? "gcc" : ENV.cc
    inreplace inreplace_files, (OPAL|PMIX)_CC_ABSOLUTE, "\"#{cc}\""
    inreplace inreplace_files_cc, (PMIX|PRTE)_CC_ABSOLUTE, "\"#{cc}\""

    ENV.cxx11
    ENV.runtime_cpu_detection

    args = %W[
      --disable-silent-rules
      --enable-ipv6
      --enable-mca-no-build=reachable-netlink
      --sysconfdir=#{etc}
      --with-hwloc=#{Formula["hwloc"].opt_prefix}
      --with-libevent=#{Formula["libevent"].opt_prefix}
      --with-pmix=#{Formula["pmix"].opt_prefix}
      --with-sge
    ]
    args << "--with-platform-optimized" if build.head?

    # Work around asm incompatibility with new linker (FB13194320)
    # https:github.comopen-mpiompiissues11935
    args << "--with-wrapper-fcflags=-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

    system ".autogen.pl", "--force" if build.head?
    system ".configure", *std_configure_args, *args
    system "make", "all"
    system "make", "check"
    system "make", "install"

    # Fortran bindings install stray `.mod` files (Fortran modules) in `lib`
    # that need to be moved to `include`.
    include.install lib.glob("*.mod")

    # Avoid references to cellar paths.
    inreplace (lib"pkgconfig").glob("*.pc"), prefix, opt_prefix, false
  end

  test do
    (testpath"hello.c").write <<~EOS
      #include <mpi.h>
      #include <stdio.h>

      int main()
      {
        int size, rank, nameLen;
        char name[MPI_MAX_PROCESSOR_NAME];
        MPI_Init(NULL, NULL);
        MPI_Comm_size(MPI_COMM_WORLD, &size);
        MPI_Comm_rank(MPI_COMM_WORLD, &rank);
        MPI_Get_processor_name(name, &nameLen);
        printf("[%d%d] Hello, world! My name is %s.\\n", rank, size, name);
        MPI_Finalize();
        return 0;
      }
    EOS
    system bin"mpicc", "hello.c", "-o", "hello"
    system ".hello"
    system bin"mpirun", ".hello"
    (testpath"hellof.f90").write <<~EOS
      program hello
      include 'mpif.h'
      integer rank, size, ierror, tag, status(MPI_STATUS_SIZE)
      call MPI_INIT(ierror)
      call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierror)
      call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)
      print*, 'node', rank, ': Hello Fortran world'
      call MPI_FINALIZE(ierror)
      end
    EOS
    system bin"mpifort", "hellof.f90", "-o", "hellof"
    system ".hellof"
    system bin"mpirun", ".hellof"

    (testpath"hellousempi.f90").write <<~EOS
      program hello
      use mpi
      integer rank, size, ierror, tag, status(MPI_STATUS_SIZE)
      call MPI_INIT(ierror)
      call MPI_COMM_SIZE(MPI_COMM_WORLD, size, ierror)
      call MPI_COMM_RANK(MPI_COMM_WORLD, rank, ierror)
      print*, 'node', rank, ': Hello Fortran world'
      call MPI_FINALIZE(ierror)
      end
    EOS
    system bin"mpifort", "hellousempi.f90", "-o", "hellousempi"
    system ".hellousempi"
    system bin"mpirun", ".hellousempi"

    (testpath"hellousempif08.f90").write <<~EOS
      program hello
      use mpi_f08
      integer rank, size, tag, status(MPI_STATUS_SIZE)
      call MPI_INIT()
      call MPI_COMM_SIZE(MPI_COMM_WORLD, size)
      call MPI_COMM_RANK(MPI_COMM_WORLD, rank)
      print*, 'node', rank, ': Hello Fortran world'
      call MPI_FINALIZE()
      end
    EOS
    system bin"mpifort", "hellousempif08.f90", "-o", "hellousempif08"
    system ".hellousempif08"
    system bin"mpirun", ".hellousempif08"
  end
end