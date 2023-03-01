class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://ghproxy.com/https://github.com/jtv/libpqxx/archive/7.7.4.tar.gz"
  sha256 "65b0a06fffd565a19edacedada1dcfa0c1ecd782cead0ee067b19e2464875c36"
  license "BSD-3-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "93b64cdbadf88442580c25807bd1ccb37c07388d784effe6930debb16892c588"
    sha256 cellar: :any,                 arm64_monterey: "eb6a34512b4dbe8441c6125e7ee1bebd045bdf5d237a9e13e61a46317a952f86"
    sha256 cellar: :any,                 arm64_big_sur:  "259df212ce00831658e97c8aa0402507ffa394bf8044bd1150e99910e1634a7d"
    sha256 cellar: :any,                 ventura:        "d49f566b9d3c80945d8304aad35b3c1c32944781556fbc173d0f5108249178e2"
    sha256 cellar: :any,                 monterey:       "dda7a525996ed368af904279787658d503150c209a70f1ea77406b1c7ae7e34c"
    sha256 cellar: :any,                 big_sur:        "a3064e182fe3c821e5b44093f5820e4b3e869f6f1ba6d095509f742d40b9653b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d31206534bff2f4bfab03669216dfbdc1befbf0c5b2ab07b1a8c3cb43ff3fe7"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on macos: :catalina # requires std::filesystem

  fails_with gcc: "5" # for C++17

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV.prepend_path "PATH", Formula["python@3.11"].opt_libexec/"bin"
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pqxx/pqxx>
      int main(int argc, char** argv) {
        pqxx::connection con;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no running postgresql server
    # system "./test"
  end
end