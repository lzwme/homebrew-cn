class S2geometry < Formula
  desc "Computational geometry and spatial indexing on the sphere"
  homepage "https://github.com/google/s2geometry"
  url "https://ghfast.top/https://github.com/google/s2geometry/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "df001f8352dce083a87b74646bcbc65fbbcd039646bda5b64adfda1e2ea32d47"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "586fc4ef544739a97e7ab80d869a82f3a41f791b000a9d589c157df462fab30f"
    sha256 cellar: :any,                 arm64_sequoia: "eaed9c2d9316cb6685daafcbc83e94141b2bd5c53598b0eda8d02c79bcd027f8"
    sha256 cellar: :any,                 arm64_sonoma:  "bc48dd50ded585c37721cc2d554a74452ac98943ba5762345ab7c8fe25ddcc51"
    sha256 cellar: :any,                 sonoma:        "9fa3d8417b79c305dd322cb159e33c5436005081726ec93402690adcd0dc849f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5840bc6b34da16172e1a997f6ae3afdec4a7f33263ce78a113a4e971a75e8d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd2ce367c61688933d4d7ae564d5521e52daebb7708b25c1ddd674abdda3b83b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"
  depends_on "openssl@3"

  def install
    # Keep C++ standard in sync with `abseil.rb`.
    args = %W[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
    ]

    # Fix missing include of unaligned.h
    # Issue ref: https://github.com/google/s2geometry/issues/481
    inreplace "CMakeLists.txt", "src/s2/util/gtl/requires.h", "\\0 src/s2/util/gtl/unaligned.h"

    system "cmake", "-S", ".", "-B", "build/shared", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args,
                    "-DBUILD_SHARED_LIBS=OFF",
                    "-DOPENSSL_USE_STATIC_LIBS=TRUE",
                    *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libs2.a"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include "s2/s2loop.h"
      #include "s2/s2polygon.h"
      #include "s2/s2latlng.h"

      #include <vector>
      #include <iostream>

      int main() {
          // Define the vertices of a polygon around a block near the Googleplex.
          std::vector<S2LatLng> lat_lngs = {
              S2LatLng::FromDegrees(37.422076, -122.084518),
              S2LatLng::FromDegrees(37.422003, -122.083984),
              S2LatLng::FromDegrees(37.421964, -122.084028),
              S2LatLng::FromDegrees(37.421847, -122.083171),
              S2LatLng::FromDegrees(37.422140, -122.083167),
              S2LatLng::FromDegrees(37.422076, -122.084518) // Last point equals the first one
          };

          std::vector<S2Point> points;
          for (const auto& ll : lat_lngs) {
              points.push_back(ll.ToPoint());
          }
          std::unique_ptr<S2Loop> loop = std::make_unique<S2Loop>(points);

          S2Polygon polygon(std::move(loop));

          S2LatLng test_point = S2LatLng::FromDegrees(37.422, -122.084);
          if (polygon.Contains(test_point.ToPoint())) {
              std::cout << "The point is inside the polygon." << std::endl;
          } else {
              std::cout << "The point is outside the polygon." << std::endl;
          }

          return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test",
      "-L#{lib}", "-ls2", "-L#{Formula["abseil"].lib}", "-labsl_log_internal_message"
    system "./test"
  end
end