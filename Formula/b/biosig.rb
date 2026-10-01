class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-3.9.8.src.tar.xz"
  sha256 "9d7298cb6e466eb3b9eb7f4c8bc501dc4c3a71dcdf2f4156bad0ca9797220422"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "53189b21bb5d69e6228230ceeaffc2e6c7e3b156f93c9f739dd118e9a83c40f2"
    sha256 cellar: :any, arm64_tahoe:       "9d69a2ebb60dc759566e07cd24b70e739692aa1251b70a365abd2de64b7a9494"
    sha256 cellar: :any, arm64_sequoia:     "39802973d3b25a519cbb9e1d13497312f7ceb4ffe9b0707f8d878f8c5c299c6c"
    sha256 cellar: :any, arm64_linux:       "85394d04e21fd4be94ca6aad6beada910adacee45a1c159b048a6a0b13931b16"
    sha256 cellar: :any, x86_64_linux:      "277bd005562cdad3d2dba34bba0e9ee1564df6290b43a6257936d010a0abe5cb"
  end

  depends_on "gawk" => :build
  depends_on "libb64" => :build
  depends_on "dcmtk"
  depends_on "suite-sparse"

  def install
    ENV.append "CXX", "-std=gnu++17"

    # Work around header include order causing issues with `#ifndef isfinite`
    ENV.append "CXXFLAGS", "-include cmath" if DevelopmentTools.clang_build_version >= 1700

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # `string_isutf8.o` is missing from the libgdf link target
    inreplace "biosig4c++/Makefile.in",
              "gdf.o gdftime.o physicalunits.o getlogin.o",
              "gdf.o gdftime.o physicalunits.o getlogin.o string_isutf8.o"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    ENV.deparallelize if OS.mac? && MacOS.version >= :sonoma
    system "make", "install"
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data",
                 shell_output("#{bin}/biosig_fhir 2>&1").strip
  end
end