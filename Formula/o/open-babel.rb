class OpenBabel < Formula
  desc "Chemical toolbox"
  homepage "https://github.com/openbabel/openbabel"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/openbabel/openbabel.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/openbabel/openbabel/releases/download/openbabel-3-1-1/openbabel-3.1.1-source.tar.bz2"
    sha256 "a6ec8381d59ea32a4b241c8b1fbd799acb52be94ab64cdbd72506fb4e2270e68"

    # Backport support for configuring PYTHON_INSTDIR to avoid Setuptools
    patch do
      url "https://github.com/openbabel/openbabel/commit/f7910915c904a18ac1bdc209b2dc9deeb92f7db3.patch?full_index=1"
      sha256 "f100bb9bffb82b318624933ddc0027eeee8546bf4d6deda5067ecbd1ebd138ea"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 5
    sha256                               arm64_tahoe:   "8aa3929bd15d13c66d1b5443dbfd8fd98e02b9cce1d63032888c915b44485d46"
    sha256                               arm64_sequoia: "65eafc217a10604751abd22e88287b1438b102ec350c5ad048d5bcdcfd2c7a7b"
    sha256                               arm64_sonoma:  "714b33b9ca188ed6ccd80f1685bd3ec3cf1d2a3943de60e406e1f796ceb93407"
    sha256                               sonoma:        "ed785e17d0df66435ca7f7e717e1c9b15bba10963fd6ba7b23d8c016e796c8d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2322af7a05a516be0a2249ab927ccdefe9017d68bd8792de30720067e9a832ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab9fd08d3145a9a52d22f61e352fcc4a32fd09ec94760c44202b5e5ffda86a15"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rapidjson" => :build
  depends_on "swig" => :build

  depends_on "cairo"
  depends_on "eigen"
  depends_on "inchi"
  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  def python3
    "python3.14"
  end

  conflicts_with "surelog", because: "both install `roundtrip` binaries"

  def install
    # Fix to error: ‘clock’ was not declared in this scope on Linux
    inreplace "include/openbabel/obutil.h", "#include <math.h>", "#include <ctime>\n\\0"

    args = %W[
      -DINCHI_INCLUDE_DIR=#{Formula["inchi"].opt_include}/inchi
      -DOPENBABEL_USE_SYSTEM_INCHI=ON
      -DRUN_SWIG=ON
      -DPYTHON_BINDINGS=ON
      -DPYTHON_EXECUTABLE=#{which(python3)}
      -DPYTHON_INSTDIR=#{prefix/Language::Python.site_packages(python3)}
    ]

    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    inreplace "CMakeLists.txt", "cmake_policy(SET CMP0042 OLD)",
                                "cmake_policy(SET CMP0042 NEW)"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match <<~EOS, shell_output("#{bin}/obabel -:'C1=CC=CC=C1Br' -omol")

        7  7  0  0  0  0  0  0  0  0999 V2000
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    0.0000    0.0000 Br  0  0  0  0  0  0  0  0  0  0  0  0
        1  6  1  0  0  0  0
        1  2  2  0  0  0  0
        2  3  1  0  0  0  0
        3  4  2  0  0  0  0
        4  5  1  0  0  0  0
        5  6  2  0  0  0  0
        6  7  1  0  0  0  0
      M  END
    EOS

    system python3, "-c", "from openbabel import openbabel"
  end
end