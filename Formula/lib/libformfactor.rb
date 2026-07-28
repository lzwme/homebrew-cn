class Libformfactor < Formula
  desc "C++ library for the efficient computation of scattering form factors"
  homepage "https://jugit.fz-juelich.de/mlz/lib/formfactor"
  url "https://jugit.fz-juelich.de/mlz/lib/formfactor/-/archive/v0.4.0/formfactor-v0.4.0.tar.bz2"
  sha256 "bb3f6a59ae906e816e68facf9721584de663fc78f9cc5ffa8f735cf6f8140b56"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "520a0d3134c2f7a8bb3f9401219ed2acd786a1949235c84b14787bc229c5172b"
    sha256 cellar: :any, arm64_sequoia: "67db57ee22845576024abde1f0a87abd86024bbbcfc4aa18d834cb65dd3a9115"
    sha256 cellar: :any, arm64_sonoma:  "45d69a4aafc2276a5a8974f74f4c2177f6ed209aa1202ccbaa81a147e76c75de"
    sha256 cellar: :any, tahoe:         "bd9245a4b05a106a2a8ad08ab2d1c5ffe320fb5c5c222c3b5abd1a2c4007eb8f"
    sha256 cellar: :any, sequoia:       "392853e478a7d8a26c3c76b3bbcfbcf682e7831ec94c8207b878d097a6ec6eb1"
    sha256 cellar: :any, sonoma:        "d14926520c1eaebb1dd8dbcbbb9a3b4ea05a06ff84b74e814456619c90039b98"
    sha256 cellar: :any, arm64_linux:   "34a51dcbb41c7d30e60ca945878f6fda942ef83e7fb983f0e8064e989ecf95cd"
    sha256 cellar: :any, x86_64_linux:  "bbecc4de9c805e827e13ec2ba0cd951cba7098fa18a1bf692cf03db74e8383a5"
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