class Gmt < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https:www.generic-mapping-tools.org"
  url "https:github.comGenericMappingToolsgmtreleasesdownload6.5.0gmt-6.5.0-src.tar.xz"
  mirror "https:mirrors.ustc.edu.cngmtgmt-6.5.0-src.tar.xz"
  sha256 "4022adb44033f9c1d5a4d275b69506449e4d486efe2218313f3ff7a6c6c3141e"
  license "LGPL-3.0-or-later"
  revision 2
  head "https:github.comGenericMappingToolsgmt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "7a9e2b2d755984f837700e435ed9f7a178d97e731c9c035471216a2bc7229b6a"
    sha256 arm64_ventura:  "d1417abc1165bddb1bf1a455daa6e9267a443cf45f80c0f0d18c004fb441a1ce"
    sha256 arm64_monterey: "829748601cadad21494b220e3cbbd9fa73bac30e5653008badb806952d4b59c9"
    sha256 sonoma:         "d208aa7a4f2583c23df3b997664c665f312246c93e6b5223cdc45e3cc2468e7e"
    sha256 ventura:        "7fae084040a7434450bac91087439904765faa73e0243c4c5c22998d398a88e1"
    sha256 monterey:       "9909ef3fdfc45c1e6832a32c32c92ca996b4cab44ea720af3001ea8afb4e0f49"
    sha256 x86_64_linux:   "0be4e41f6fd938a58ccd09f4afc9d2b11df44c4f30120074e542ea96ac26cdc4"
  end

  depends_on "cmake" => :build

  depends_on "fftw"
  depends_on "gdal"
  depends_on "geos"
  depends_on "netcdf"
  depends_on "openblas"
  depends_on "pcre2"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "gshhg" do
    url "https:github.comGenericMappingToolsgshhg-gmtreleasesdownload2.3.7gshhg-gmt-2.3.7.tar.gz"
    mirror "https:mirrors.ustc.edu.cngmtgshhg-gmt-2.3.7.tar.gz"
    sha256 "9bb1a956fca0718c083bef842e625797535a00ce81f175df08b042c2a92cfe7f"
  end

  resource "dcw" do
    url "https:github.comGenericMappingToolsdcw-gmtreleasesdownload2.2.0dcw-gmt-2.2.0.tar.gz"
    mirror "https:mirrors.ustc.edu.cngmtdcw-gmt-2.2.0.tar.gz"
    sha256 "f2a8a7b7365bdd17269aa1d412966a871528eefa9b2a7409815832a702ff7dcb"
  end

  def install
    (buildpath"gshhg").install resource("gshhg")
    (buildpath"dcw").install resource("dcw")

    # GMT_DOCDIR and GMT_MANDIR must be relative paths
    args = %W[
      -DGMT_DOCDIR=sharedocgmt
      -DGMT_MANDIR=shareman
      -DGSHHG_ROOT=#{buildpath}gshhg
      -DCOPY_GSHHG:BOOL=TRUE
      -DDCW_ROOT=#{buildpath}dcw
      -DCOPY_DCW:BOOL=TRUE
      -DPCRE_ROOT=FALSE
      -DFFTW3_ROOT=#{Formula["fftw"].opt_prefix}
      -DGDAL_ROOT=#{Formula["gdal"].opt_prefix}
      -DNETCDF_ROOT=#{Formula["netcdf"].opt_prefix}
      -DPCRE2_ROOT=#{Formula["pcre2"].opt_prefix}
      -DFLOCK:BOOL=TRUE
      -DGMT_INSTALL_MODULE_LINKS:BOOL=FALSE
      -DGMT_INSTALL_TRADITIONAL_FOLDERNAMES:BOOL=FALSE
      -DLICENSE_RESTRICTED:BOOL=FALSE
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    inreplace bin"gmt-config", Superenv.shims_pathENV.cc, DevelopmentTools.locate(ENV.cc)
  end

  def caveats
    <<~EOS
      GMT needs Ghostscript for the 'psconvert' command to convert PostScript files
      to other formats. To use 'psconvert', please 'brew install ghostscript'.

      GMT needs FFmpeg for the 'movie' command to make movies in MP4 or WebM format.
      If you need this feature, please 'brew install ffmpeg'.

      GMT needs GraphicsMagick for the 'movie' command to make animated GIFs.
      If you need this feature, please 'brew install graphicsmagick'.
    EOS
  end

  test do
    system "#{bin}gmt pscoast -R0360-7070 -Jm1.2e-2i -Ba60f30a30f15 -Dc -G240 -W10 -P > test.ps"
    assert_predicate testpath"test.ps", :exist?
  end
end