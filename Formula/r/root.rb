class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "https:root.cern.ch"
  url "https:root.cern.chdownloadroot_v6.30.04.source.tar.gz"
  sha256 "2b4180b698f39cc65d91084d833a884515b325bc5f673c8e39abe818b025d8cc"
  license "LGPL-2.1-or-later"
  head "https:github.comroot-projectroot.git", branch: "master"

  livecheck do
    url "https:root.cerninstallall_releases"
    regex(%r{Release\s+v?(\d+(?:[.]\d*[02468])+)[ >]}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match[0].tr("", ".") }
    end
  end

  bottle do
    sha256 arm64_sonoma:   "dacfe11fa048be0850bb3f8d6063b2eabd45179ca5e0db6d38a12b7a5723f942"
    sha256 arm64_ventura:  "b3235f9c9d75696a6d257e934535382db6e951b91dde71f2b58421c8496f1398"
    sha256 arm64_monterey: "2c3be78e473e1b9ef477403207ab51bac76bbce245c261aafb5ef7a6220614e2"
    sha256 sonoma:         "3844e74c8b2a1654e2f5ad3dae992dca30c6e9fcf0f3a22c4484eff7ddc9bdf7"
    sha256 ventura:        "a2e4a35baf6703261cec740f62aa6f6e49dc5a3f6b7bdd7144c56be4651c923d"
    sha256 monterey:       "47d12445b293713b6b865bd1fcd8e020eef75e0cffae82a11110dae605d3888b"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cfitsio"
  depends_on "davix"
  depends_on "fftw"
  depends_on "freetype"
  depends_on "ftgl"
  depends_on "gcc" # for gfortran
  depends_on "gl2ps"
  depends_on "glew"
  depends_on "graphviz"
  depends_on "gsl"
  depends_on "lz4"
  depends_on "mysql-client"
  depends_on "nlohmann-json"
  depends_on "numpy" # for tmva
  depends_on "openblas"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "python@3.11"
  depends_on "sqlite"
  depends_on "tbb"
  depends_on :xcode
  depends_on "xrootd"
  depends_on "xxhash"
  depends_on "xz" # for LZMA
  depends_on "zstd"

  uses_from_macos "libxcrypt"
  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libxft"
    depends_on "libxpm"
  end

  skip_clean "bin"

  fails_with gcc: "5"

  def python3
    "python3.11"
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}root"
    ENV.remove "HOMEBREW_INCLUDE_PATHS", Formula["util-linux"].opt_include if OS.mac?

    inreplace "cmakemodulesSearchInstalledSoftware.cmake" do |s|
      # Enforce secure downloads of vendored dependencies. These are
      # checksummed in the cmake file with sha256.
      s.gsub! "http:lcgpackages", "https:lcgpackages"
      # Patch out check that skips using brewed glew.
      s.gsub! "CMAKE_VERSION VERSION_GREATER 3.15", "CMAKE_VERSION VERSION_GREATER 99.99"
    end

    args = std_cmake_args + %W[
      -DCLING_CXX_PATH=clang++
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_INSTALL_ELISPDIR=#{elisp}
      -DPYTHON_EXECUTABLE=#{python3}
      -DXROOTD_ROOT_DIR=#{Formula["xrootd"].opt_prefix}
      -Dbuiltin_afterimage=ON
      -Dbuiltin_cfitsio=OFF
      -Dbuiltin_clang=ON
      -Dbuiltin_cling=ON
      -Dbuiltin_cppzmq=OFF
      -Dbuiltin_davix=OFF
      -Dbuiltin_fftw3=OFF
      -Dbuiltin_freetype=OFF
      -Dbuiltin_ftgl=OFF
      -Dbuiltin_gl2ps=OFF
      -Dbuiltin_glew=OFF
      -Dbuiltin_gsl=OFF
      -Dbuiltin_llvm=ON
      -Dbuiltin_lz4=OFF
      -Dbuiltin_lzma=OFF
      -Dbuiltin_nlohmannjson=OFF
      -Dbuiltin_openssl=OFF
      -Dbuiltin_openui5=ON
      -Dbuiltin_pcre=OFF
      -Dbuiltin_tbb=OFF
      -Dbuiltin_unuran=OFF
      -Dbuiltin_vc=OFF
      -Dbuiltin_vdt=ON
      -Dbuiltin_veccore=OFF
      -Dbuiltin_xrootd=OFF
      -Dbuiltin_xxhash=OFF
      -Dbuiltin_zeromq=OFF
      -Dbuiltin_zlib=OFF
      -Dbuiltin_zstd=OFF
      -Dcfitsio=ON
      -Ddavix=ON
      -Ddev=OFF
      -Dfail-on-missing=ON
      -Dfftw3=ON
      -Dfitsio=ON
      -Dfortran=ON
      -Dfreetype=ON
      -Dgdml=ON
      -Dgfal=OFF
      -Dgnuinstall=ON
      -Dimt=ON
      -Dmathmore=ON
      -Dminuit2=ON
      -Dmysql=ON
      -Docaml=OFF
      -Doracle=OFF
      -Dpgsql=OFF
      -Dpyroot=ON
      -Dpythia6=OFF
      -Dpythia8=OFF
      -Droofit=ON
      -Dssl=ON
      -Dtmva=ON
      -Dvdt=ON
      -Dxrootd=ON
      -GNinja
    ]

    # Workaround the shim directory being embedded into the output
    inreplace "buildunixcompiledata.sh", "`type -path $CXX`", ENV.cxx

    # Homebrew now sets CMAKE_INSTALL_LIBDIR to lib, which is incorrect
    # for ROOT with gnuinstall, so we set it back here.
    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args(install_libdir: "libroot")
    system "cmake", "--build", "builddir"
    system "ctest", "-R", "tutorial-tree", "--verbose", "--parallel", ENV.make_jobs, "--test-dir", "builddir"
    system "cmake", "--install", "builddir"

    chmod 0755, bin.glob("*.*sh")

    pth_contents = "import site; site.addsitedir('#{lib}root')\n"
    (prefixLanguage::Python.site_packages(python3)"homebrew-root.pth").write pth_contents
  end

  def caveats
    <<~EOS
      As of ROOT 6.22, you should not need the thisroot scripts; but if you
      depend on the custom variables set by them, you can still run them:

      For bash users:
        . #{HOMEBREW_PREFIX}binthisroot.sh
      For zsh users:
        pushd #{HOMEBREW_PREFIX} >devnull; . binthisroot.sh; popd >devnull
      For cshtcsh users:
        source #{HOMEBREW_PREFIX}binthisroot.csh
      For fish users:
        . #{HOMEBREW_PREFIX}binthisroot.fish
    EOS
  end

  test do
    (testpath"test.C").write <<~EOS
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    EOS

    # Test ROOT command line mode
    system bin"root", "-b", "-l", "-q", "-e", "gSystem->LoadAllLibraries(); 0"

    # Test ROOT executable
    assert_equal "\nProcessing test.C...\nHello, world!\n",
                 shell_output("#{bin}root -l -b -n -q test.C")

    # Test ACLiC
    assert_equal "\nProcessing test.C+...\nHello, world!\n",
                 shell_output("#{bin}root -l -b -n -q test.C+")

    # Test linking
    (testpath"test.cpp").write <<~EOS
      #include <iostream>
      #include <TString.h>
      int main() {
        std::cout << TString("Hello, world!") << std::endl;
        return 0;
      }
    EOS
    flags = %w[cflags libs ldflags].map { |f| "$(#{bin}root-config --#{f})" }
    flags << "-Wl,-rpath,#{lib}root"
    shell_output("$(#{bin}root-config --cxx) test.cpp #{flags.join(" ")}")
    assert_equal "Hello, world!\n", shell_output(".a.out")

    # Test Python module
    system python3, "-c", "import ROOT; ROOT.gSystem.LoadAllLibraries()"
  end
end