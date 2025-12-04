class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://ghfast.top/https://github.com/facebookresearch/faiss/archive/refs/tags/v1.13.1.tar.gz"
  sha256 "89e6e9e3eb14a5948b9b8b57656de2dae9a1f0f7aceb5a2268e5eded33e5d6cf"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d1aceddd104b73cfe3b94d32dc828d0d0de7be54c1304865b04bc6ff74105c75"
    sha256 cellar: :any,                 arm64_sequoia: "d0bd2d1815defa4249c4d348c33f3fbde3f110745098d7481b3b7eaf49cb7a3a"
    sha256 cellar: :any,                 arm64_sonoma:  "4f8bc8b80f6da76e6d1c32422f14ce746003a5e370f32f021cb93d45ba19f905"
    sha256 cellar: :any,                 sonoma:        "fd9d7b9d7716531edb1b85fcf124b51403a33206154611efbaed1c19e3760898"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d4ff03b294230064583553f69286c091c84baefc3cdb324902183046f261467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5e3892a6c27b7dfbd866d4aa1ff2f17afdd0d6fa67b62b07ba2ff7e54b13c29"
  end

  depends_on "cmake" => :build
  depends_on "openblas"

  on_macos do
    depends_on "libomp"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DFAISS_ENABLE_C_API=ON
      -DFAISS_ENABLE_GPU=OFF
      -DFAISS_ENABLE_PYTHON=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "demos"
  end

  test do
    cp pkgshare/"demos/demo_imi_flat.cpp", testpath
    system ENV.cxx, "-std=c++11", "demo_imi_flat.cpp", "-L#{lib}", "-lfaiss", "-o", "test"
    assert_match "Query results", shell_output("./test")
  end
end