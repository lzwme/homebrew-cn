class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "https://pqxx.org/development/libpqxx/"
  url "https://ghfast.top/https://github.com/jtv/libpqxx/archive/refs/tags/7.10.4.tar.gz"
  sha256 "e578677d0c1b0f7ad37ac2d9ac373bc9738a3732083c70672da5f2c3028e6b03"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "721337b9c2036cd4447a9ad057b23fa8eef633def66bd17d3a36d38bd30794fd"
    sha256 cellar: :any,                 arm64_sequoia: "775bbd42e18973bb8690aa02918df1ff08c5aacc8ac3e0e15cbae6e5ddce5928"
    sha256 cellar: :any,                 arm64_sonoma:  "6a49ea069ee9e0e2f89da4ce5d6a5defeb095c864331db666f27a90b2db0ea6c"
    sha256 cellar: :any,                 sonoma:        "b914889ff96650eed6930ca74f51bc10db881d7a11637c0685d3222ab29082ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "331f1728270a260ceffee580203df246d40dd3b6e35450d9dc5e4b4346f6dfc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b373de2f4a90fcba7e40f3b4a27250ce370dedd8a0f77f2cc46ad77f7ba34f65"
  end

  depends_on "pkgconf" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"

  uses_from_macos "python" => :build

  def install
    ENV.append "CXXFLAGS", "-std=c++17"
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    system "./configure", "--disable-silent-rules", "--enable-shared", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <pqxx/pqxx>
      int main(int argc, char** argv) {
        pqxx::connection con;
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no running postgresql server
    # system "./test"
  end
end