class S2geometry < Formula
  desc "Computational geometry and spatial indexing on the sphere"
  homepage "https://github.com/google/s2geometry"
  url "https://ghfast.top/https://github.com/google/s2geometry/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "8c1f0a4b98472ed9df9807f5ec10ee57928cca388e16c13f430b652790d3ad8b"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fa880452aefe1999c798e2847d20161f9eb76d366194406f00369e0c0971ef79"
    sha256 cellar: :any, arm64_sequoia: "55118e09389f1d9204e65813e6b9c61332c034f94ee8193f0753919a8e82bd3f"
    sha256 cellar: :any, arm64_sonoma:  "fce87c6c9e14fc3c05815a7a5851a276bcca7a71003dfa3ca253dd885b911954"
    sha256 cellar: :any, sonoma:        "58d63ab77037433eaf0e7b84f15b166fe086c0e8a4b2d0143874196a1fe73f93"
    sha256 cellar: :any, arm64_linux:   "fb3ebc23fda8389578e84be561c04b81db93bdf9b1cb02eaba70887fc4d90f91"
    sha256 cellar: :any, x86_64_linux:  "48d4f6cf7c0b4e5238d97c9676319cfa1d69ed71907bf3334623c31b5b2d8155"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "abseil"

  # Backport abseil 20260526.0 build fix (throw_delegate moved to a public header).
  patch do
    url "https://github.com/google/s2geometry/commit/424bc82d412cb939412e0952c1b3da22b5e19d66.patch?full_index=1"
    sha256 "adebc643e21044eb440bf07dbf7dc22ac1aae8eb448249592200fcdecc00c05b"
    type :backport
    resolves "https://github.com/google/s2geometry/pull/653"
  end

  def install
    # Keep C++ standard in sync with `abseil.rb`.
    args = %w[
      -DBUILD_TESTS=OFF
      -DCMAKE_CXX_STANDARD=17
    ]

    system "cmake", "-S", ".", "-B", "build/shared", *args, *std_cmake_args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static", *args,
                    "-DBUILD_SHARED_LIBS=OFF",
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