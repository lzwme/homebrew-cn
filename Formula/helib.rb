class Helib < Formula
  desc "Implementation of homomorphic encryption"
  homepage "https://github.com/homenc/HElib"
  url "https://ghproxy.com/https://github.com/homenc/HElib/archive/v2.3.0.tar.gz"
  sha256 "05c87f2b50d4774e16868ba61a7271930dd67f4ad137f30eb0f310969377bc20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fcbf73389a3e7c97b6094b2fbac15446ceba4d79326c174cce1a136a4321edf9"
    sha256 cellar: :any,                 arm64_monterey: "fc4e3cdfee251e095c0dd3527d2b4ae11909c3b71a79f8d48166ee267492be0b"
    sha256 cellar: :any,                 arm64_big_sur:  "7821f76c654d9a08cb613f7127b9932241726c49c6f5a3225b232deb0a5fad78"
    sha256 cellar: :any,                 ventura:        "b3daa3e53fdce0c3961eddfac1476cba433db1eebe96047a89be9164adb788cf"
    sha256 cellar: :any,                 monterey:       "2678f6fedfb79ed9b30a086ce2d05a6f551ab9ddced48582d50fad2340d92c6d"
    sha256 cellar: :any,                 big_sur:        "dec80000dc1431cef027b67fab14c516248994758c9a2b8a45ea411dcea27584"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e209862dd2093cd1d27e94f10a7403b4fa2d3b258c197d4aeaf3d3af7ecbd3a"
  end

  depends_on "cmake" => :build
  depends_on "bats-core" => :test
  depends_on "gmp"
  depends_on "ntl"

  fails_with gcc: "5" # for C++17

  def install
    mkdir "build" do
      system "cmake", "-DBUILD_SHARED=ON", "..", *std_cmake_args
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/BGV_country_db_lookup/BGV_country_db_lookup.cpp", testpath/"test.cpp"
    mkdir "build"
    system ENV.cxx, "test.cpp", "-std=c++17", "-L#{lib}", "-L#{Formula["ntl"].opt_lib}",
                    "-pthread", "-lhelib", "-lntl", "-o", "build/BGV_country_db_lookup"

    cp_r pkgshare/"examples/tests", testpath
    system "bats", "."
  end
end