class Coacd < Formula
  desc "Approximate convex decomposition for 3D meshes with collision-aware concavity"
  homepage "https://github.com/SarahWeiii/CoACD"
  url "https://ghfast.top/https://github.com/SarahWeiii/CoACD/archive/refs/tags/1.0.12.tar.gz"
  sha256 "9357bd6da525127ce538f6f0a3996e33573089848449bd70a2ae0c9bb82966c6"
  license "MIT"

  head "https://github.com/SarahWeiii/CoACD.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "83ca233838964637ff85cc749f565f5385b0e181ddb69452af0ff8f2623b92ab"
    sha256 cellar: :any, arm64_sequoia: "18fc2d14e9b128ffa926834167fa1e921926a769342a9f78ddb27e606889f368"
    sha256 cellar: :any, arm64_sonoma:  "8706c6c23bd27ada580c0ae287a97db48eee340b32ca55e40c23420fb00d01d5"
    sha256 cellar: :any, sonoma:        "04c5ec45be4d1eed41e046ba6b6eda936fdb4a98943256b73279c4527dd73e43"
    sha256 cellar: :any, arm64_linux:   "0de096a5ece2b61d2fd5c9b6c91ab0dd2aa1c7aaa2921be41f0f86b9ea16bbb6"
    sha256 cellar: :any, x86_64_linux:  "cd9ddee7b59615a3a1d04faee0c896a4327a751cbb5738f5655963011ce9fa66"
  end

  depends_on "cmake" => :build

  resource "cdt" do
    url "https://github.com/artem-ogre/CDT.git",
        revision: "ec03b309fd18102ab1da069f2edf3b37be5d1fb3"
  end

  def install
    resource("cdt").stage(buildpath/"3rd/cdt")

    args = %w[
      -DWITH_3RD_PARTY_LIBS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <CoACD/coacd.h>
      #include <cassert>

      int main() {
        coacd::Mesh input;
        input.vertices = {{0.0, 0.0, 0.0}, {1.0, 0.0, 0.0}, {0.0, 1.0, 0.0}, {0.0, 0.0, 1.0}};
        input.indices  = {{0, 1, 2}, {0, 2, 3}, {0, 3, 1}, {1, 3, 2}};
        auto result = coacd::CoACD(input, 0.5, -1, "off", 50, 2000, 20, 100, 3, false, false);
        assert(!result.empty());
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++20", "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test", "-l_coacd"
    system "./test"
  end
end