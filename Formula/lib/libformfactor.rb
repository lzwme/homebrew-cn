class Libformfactor < Formula
  desc "C++ library for the efficient computation of scattering form factors"
  homepage "https://jugit.fz-juelich.de/mlz/lib/formfactor"
  url "https://jugit.fz-juelich.de/mlz/lib/formfactor/-/archive/v0.5.0/formfactor-v0.5.0.tar.bz2"
  sha256 "b51f0ba808798ac2cae1842a53109dd0da3e085e7501fb1bb655782ff063d7c0"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5284cb7bbd380f0d354e8fcb78c9e4d16d97c9c3bc75d593879be439c750d0c0"
    sha256 cellar: :any, arm64_sequoia: "2399d704c93cd976acfc80475bad849f6ceec41ea0b451cb94d99333a1953cd6"
    sha256 cellar: :any, arm64_sonoma:  "2a00c922906fdd35e2e59ded3baca81b5102e34d5c2c0eb0cf9a4bab00d303b0"
    sha256 cellar: :any, tahoe:         "4c252d4add69a236c893f149b68ec27873ad5ec3d96c56950308d0acc30dfc95"
    sha256 cellar: :any, sequoia:       "8c57f40053ad1a5c85a0396093710bba8d703ec2ca701148475705206e911fac"
    sha256 cellar: :any, sonoma:        "05056f3cb7dba73c1224e6ff26b494522d6c60e32149f35184208bc271648699"
    sha256 cellar: :any, arm64_linux:   "0368ee7b03e9dd519ba2ea74c200d9975da86f7ff75e26956ebe6bc8bcaa0b61"
    sha256 cellar: :any, x86_64_linux:  "d8a9746ca2f2bf79be5b32af3e07895ca01d6efc08d79ef911509d7a6758886f"
  end

  depends_on "cmake" => :build
  depends_on "libheinz"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLibHeinz_DIR=#{formula_opt_prefix("libheinz")}/cmake",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"fftest.cpp").write <<~CPP
      #include <ff/Face.h>
      #include <ff/Prism.h>
      #include <ff/Polyhedron.h>
      #include <cmath>  // abs

      bool CHECK_NEAR(const double value, const double expected, const double tol)
      {
        return std::abs(value - expected) <= tol;
      }

      bool test_asPolyhedron_prism()
      {
        ff::Prism prism(false, 1, {{-0.5, -0.5, 0}, {-0.5, 0.5, 0}, {0.5, 0.5, 0}, {0.5, -0.5, 0}});
        ff::Polyhedron* polyhedron = prism.asPolyhedron();

        const bool test0 = (polyhedron->faces().size() == 6);
        const bool test1 = CHECK_NEAR(polyhedron->vertices()[4].z(), 0.5, 1E-13);
        const bool test2 = CHECK_NEAR(polyhedron->vertices()[5].z(), 0.5, 1E-13);
        const bool test3 = CHECK_NEAR(polyhedron->vertices()[6].z(), 0.5, 1E-13);
        const bool test4 = CHECK_NEAR(polyhedron->vertices()[7].z(), 0.5, 1E-13);

        return test0 && test1 && test2 && test3 && test4;
      }

      bool test_faceCenter_CenteredRectangle()
      {
        // FaceCenter:CenteredRectangle
        ff::Face face({{-0.5, -1.4, 0}, {-0.5, 1.4, 0}, {0.5, 1.4, 0}, {0.5, -1.4, 0}}, true);
        const R3 center = face.center_of_polygon();
        const bool test1 = std::abs(center.x()) <= 1e-13;
        const bool test2 = std::abs(center.y()) <= 1e-13;
        const bool test3 = std::abs(center.z()) <= 1e-13;

        return test1 && test2 && test3;
      }

      int main()
      {
        const bool all_tests = test_asPolyhedron_prism() && test_faceCenter_CenteredRectangle();
        return all_tests? 0 : 1;
      }
    CPP

    system ENV.cxx, "-std=c++20", "fftest.cpp", "-I#{include}", "-L#{lib}", "-lformfactor", "-o", "fftest"
    system "./fftest"
  end
end