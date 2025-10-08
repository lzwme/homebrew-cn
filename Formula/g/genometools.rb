class Genometools < Formula
  desc "Versatile open source genome analysis software"
  homepage "https://genometools.org/"
  # genometools does not have source code on par with their binary dist on their website
  url "https://ghfast.top/https://github.com/genometools/genometools/archive/refs/tags/v1.6.6.tar.gz"
  sha256 "cc5d92c44708a4566a07650bbe7e9009fb602262548427814c04d3a7043d26e9"
  license "ISC"
  head "https://github.com/genometools/genometools.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ede4a7e7dca0d91a489fd52b39da3aee15419f7789379622c2226946f96c701d"
    sha256 cellar: :any,                 arm64_sequoia: "6a740b3d95366de0bb83169ff008ff123e5f518e4979bc149baab5c4f7c5d57b"
    sha256 cellar: :any,                 arm64_sonoma:  "df602fd3a92a0b8247534d5f4d7694ca2813844e35dea1a25d7d31490fc0e118"
    sha256                               sonoma:        "0dcd7cb3695785f842caa136a32a54dd40521f82c41d86cb6104636fd63dde41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d98999031a025a7e137b9020637f62fbf6eceabc8d2c91549ff6453374d054cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31172f7051f88d8953348b1ba434ce27648955f3ec9734bbffa1dc41bdc90b20"
  end

  depends_on "pkgconf" => :build
  depends_on "python@3.13" => [:build, :test]
  depends_on "cairo"
  depends_on "glib"
  depends_on "pango"
  depends_on "tre"

  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  conflicts_with "libslax", because: "both install `bin/gt`"

  def python3
    which("python3.13")
  end

  def install
    # Workaround for arm64 linux from char being unsigned.
    # Same root cause as https://github.com/genometools/genometools/issues/311
    ENV.append_to_cflags "-fsigned-char" if OS.linux? && Hardware::CPU.arm?

    # Manually unbundle as useshared=yes requires Lua 5.1 and older SAMtools
    rm_r(Dir["src/external/{bzip2,expat,sqlite,tre,zlib}*"])

    system "make", "install", "prefix=#{prefix}",
                              "ADDITIONAL_SO_DEPS=",
                              "ADDITIONAL_ZLIBS=",
                              "DEPLIBS=-lbz2 -lz -lexpat -ltre -lsqlite3",
                              "LIBBZ2_SRC=",
                              "LIBEXPAT_SRC=",
                              "LIBTRE_SRC=",
                              "OVERRIDELIBS=",
                              "SQLITE3_SRC=",
                              "ZLIB_SRC="

    cd "gtpython" do
      # Use the shared library from this specific version of genometools.
      inreplace "gt/dlload.py",
        "gtlib = CDLL(\"libgenometools\" + soext)",
        "gtlib = CDLL(\"#{lib}/libgenometools\" + soext)"

      system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
      system python3, "-m", "unittest", "discover", "tests"
    end
  end

  test do
    system bin/"gt", "-test"
    system python3, "-c", "import gt"
  end
end