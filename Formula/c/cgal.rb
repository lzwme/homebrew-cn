class Cgal < Formula
  desc "Computational Geometry Algorithms Library"
  homepage "https:www.cgal.org"
  url "https:github.comCGALcgalreleasesdownloadv5.6.1CGAL-5.6.1.tar.xz"
  sha256 "cdb15e7ee31e0663589d3107a79988a37b7b1719df3d24f2058545d1bcdd5837"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "70d4bde9024c3e8215eaeba6043275bbd71e7b5635d36710515726808c60db09"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt@5" => :test
  depends_on "boost"
  depends_on "eigen"
  depends_on "gmp"
  depends_on "mpfr"

  on_linux do
    depends_on "openssl@3"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Ensure that the various `Find*` modules look in HOMEBREW_PREFIX.
    # This also helps guarantee uniform bottles.
    inreplace_files = %w[
      CGAL_Common.cmake
      FindESBTL.cmake
      FindGLPK.cmake
      FindIPE.cmake
      FindLASLIB.cmake
      FindMKL.cmake
      FindOSQP.cmake
      FindOpenMesh.cmake
      FindSuiteSparse.cmake
    ]
    inreplace inreplace_files.map { |file| lib"cmakeCGAL"file }, "usrlocal", HOMEBREW_PREFIX
  end

  test do
    # https:doc.cgal.orglatestTriangulation_2Triangulation_2_2draw_triangulation_2_8cpp-example.html and  https:doc.cgal.orglatestAlgebraic_foundationsAlgebraic_foundations_2interoperable_8cpp-example.html
    (testpath"surprise.cpp").write <<~EOS
      #include <CGALExact_predicates_inexact_constructions_kernel.h>
      #include <CGALTriangulation_2.h>
      #include <CGALdraw_triangulation_2.h>
      #include <CGALbasic.h>
      #include <CGALCoercion_traits.h>
      #include <CGALIOio.h>
      #include <fstream>
      typedef CGAL::Exact_predicates_inexact_constructions_kernel K;
      typedef CGAL::Triangulation_2<K>                            Triangulation;
      typedef Triangulation::Point                                Point;

      template <typename A, typename B>
      typename CGAL::Coercion_traits<A,B>::Type
      binary_func(const A& a , const B& b){
          typedef CGAL::Coercion_traits<A,B> CT;
          CGAL_static_assertion((CT::Are_explicit_interoperable::value));
          typename CT::Cast cast;
          return cast(a)*cast(b);
      }

      int main(int argc, char**) {
        std::cout<< binary_func(double(3), int(5)) << std::endl;
        std::cout<< binary_func(int(3), double(5)) << std::endl;
        std::ifstream in("datatriangulation_prog1.cin");
        std::istream_iterator<Point> begin(in);
        std::istream_iterator<Point> end;
        Triangulation t;
        t.insert(begin, end);
        if(argc == 3)  do not test Qt5 at runtime
          CGAL::draw(t);
        return EXIT_SUCCESS;
       }
    EOS
    (testpath"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.1...3.15)
      find_package(CGAL COMPONENTS Qt5)
      add_definitions(-DCGAL_USE_BASIC_VIEWER -DQT_NO_KEYWORDS)
      include_directories(surprise BEFORE SYSTEM #{Formula["qt@5"].opt_include})
      add_executable(surprise surprise.cpp)
      target_include_directories(surprise BEFORE PUBLIC #{Formula["qt@5"].opt_include})
      target_link_libraries(surprise PUBLIC CGAL::CGAL_Qt5)
    EOS
    system "cmake", "-L", "-DQt5_DIR=#{Formula["qt@5"].opt_lib}cmakeQt5",
           "-DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_lib}",
           "-DCMAKE_BUILD_RPATH=#{HOMEBREW_PREFIX}lib", "-DCMAKE_PREFIX_PATH=#{prefix}", "."
    system "cmake", "--build", ".", "-v"
    assert_equal "15\n15", shell_output(".surprise").chomp
  end
end