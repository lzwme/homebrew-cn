class Immer < Formula
  desc "Library of persistent and immutable data structures written in C++"
  homepage "https://sinusoid.es/immer/"
  url "https://ghproxy.com/https://github.com/arximboldi/immer/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "de8411c84830864604bb685dc8f2e3c0dbdc40b95b2f6726092f7dcc85e75209"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e1dc5c791931d0887a5f7ba54e96d8f36f6b2dd63dea423432953f996025c325"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  def install
    args = %w[
      -Dimmer_BUILD_EXAMPLES=OFF
      -Dimmer_BUILD_EXTRAS=OFF
      -Dimmer_BUILD_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args.reject { |s| s["-DBUILD_TESTING=OFF"] }
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <immer/vector.hpp>
      int main()
      {
          const auto v0 = immer::vector<int>{};
          const auto v1 = v0.push_back(13);
          assert(v0.size() == 0 && v1.size() == 1 && v1[0] == 13);

          const auto v2 = v1.set(0, 42);
          assert(v1[0] == 13 && v2[0] == 42);
      }
    EOS

    system ENV.cxx, "-std=c++14", "-I#{include}", "test.cpp", "-o", "test"
    system "./test"
  end
end