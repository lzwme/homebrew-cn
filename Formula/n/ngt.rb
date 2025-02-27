class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https:github.comyahoojapanNGT"
  url "https:github.comyahoojapanNGTarchiverefstagsv2.3.12.tar.gz"
  sha256 "1a7a821806574c04fd5f3428c9cbde4acd6f001e9c16899b4172ba733ffa2274"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "076c6ccf331fece0614fce0715ebe03a27b8a4656f49e52280becf28107340d2"
    sha256 cellar: :any,                 arm64_sonoma:  "904416d494dc110177066246b3cd9ba457499e12fe9a5c39b36018309b3eb3fe"
    sha256 cellar: :any,                 arm64_ventura: "50a4035514d26a4479153af928f760d60d9d6354423a665763895b45de9cb71e"
    sha256 cellar: :any,                 sonoma:        "873763ba60f508a6c92bef8627a581a1e403f3a14a8cebc42bd6d4c1fdd9d90e"
    sha256 cellar: :any,                 ventura:       "eb181d17e5f68d17e611fb022b4224ecb6f0ba1ff14784adc48d877ddbbdd1b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab0ef52071db80effec20829597220e64eee16f9f586ec1007d3b1782b7a2941"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DNGT_BFLOAT_DISABLED=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare"data"), testpath
    system bin"ngt", "-d", "128", "-o", "c", "create", "index", "datasift-dataset-5k.tsv"
  end
end