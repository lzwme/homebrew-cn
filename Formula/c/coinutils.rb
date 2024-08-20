class Coinutils < Formula
  desc "COIN-OR utilities"
  homepage "https:github.comcoin-orCoinUtils"
  url "https:github.comcoin-orCoinUtilsarchiverefstagsreleases2.11.12.tar.gz"
  sha256 "eef1785d78639b228ae2de26b334129fe6a7d399c4ac6f8fc5bb9054ba00de64"
  license "EPL-2.0"
  head "https:github.comcoin-orCoinUtils.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{^(?:releases)?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "5d9193efa0d87646822efcf4184544d50b3e0340d85fc65de79f24b170a09c37"
    sha256 cellar: :any,                 arm64_ventura:  "b041fbad7adfee8ff45bef91c76c6c154599b662199b350268acd4206b6c3790"
    sha256 cellar: :any,                 arm64_monterey: "1a3df4e2351ee15be1d0dd33f63516457cd82ec3ee25a018f53d79cbac19a2cc"
    sha256 cellar: :any,                 sonoma:         "fd5cccbd3701e3df7a839b033758d9f89875145301eab36151f7199c20f41773"
    sha256 cellar: :any,                 ventura:        "74fa09ea8b717beaba24b5320e452f0d2d1856b567add648ca67181e47902338"
    sha256 cellar: :any,                 monterey:       "5e926b104d3e5bfa2764a33aafca6eabc9f381ffecb385fa3e10bfa69035e76d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4edc2b29842e702e87695df91ab2044beec5cc72aaf454af76e8265eac83bef"
  end

  depends_on "pkg-config" => :build
  depends_on "openblas"

  uses_from_macos "zlib"

  def install
    args = [
      "--datadir=#{pkgshare}",
      "--includedir=#{include}coinutils",
      "--with-blas-incdir=#{Formula["openblas"].opt_include}",
      "--with-blas-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-lapack-incdir=#{Formula["openblas"].opt_include}",
      "--with-lapack-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
    ]

    system ".configure", *args, *std_configure_args
    system "make"
    # Deparallelize due to error 1: "mkdir: #{include}coinutilscoin: File exists."
    # https:github.comcoin-orClpissues109
    ENV.deparallelize { system "make", "install" }
  end

  test do
    resource "homebrew-coin-or-tools-data-sample-p0201-mps" do
      url "https:raw.githubusercontent.comcoin-or-toolsData-Samplereleases1.2.11p0201.mps"
      sha256 "8352d7f121289185f443fdc67080fa9de01e5b9bf11b0bf41087fba4277c07a4"
    end

    testpath.install resource("homebrew-coin-or-tools-data-sample-p0201-mps")

    (testpath"test.cpp").write <<~EOS
      #include <CoinMpsIO.hpp>
      int main() {
        CoinMpsIO mpsIO;
        return mpsIO.readMps("#{testpath}p0201.mps");
      }
    EOS

    system ENV.cxx, "test.cpp", "-I#{opt_include}coinutilscoin",
      "-L#{opt_lib}", "-lCoinUtils"
    system ".a.out"
  end
end