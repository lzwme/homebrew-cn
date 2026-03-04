class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://ghfast.top/https://github.com/facebookresearch/faiss/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "48db37fc2e7a2bab74cff79318f62bd4430dbd42942b0778241454079f5d05c8"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c563eb347a2a968e11d5e4ea86e5dc682726d18fa77c15b2306d10235fc3acd8"
    sha256 cellar: :any,                 arm64_sequoia: "699c27462066185e4e192ef0ff80cea279f75e16d7a7bd1526fc3284e67d4e8a"
    sha256 cellar: :any,                 arm64_sonoma:  "33481b8cfb9949a970c6c217aaaf23813bc85744f7a3f6cb6b0878de44c7865d"
    sha256 cellar: :any,                 sonoma:        "27e882672ecc18a11a599b56f43371c2b33b47c80e913d4e67ea58a4553061fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ea0259f0c10b1b2ffc150ff793fdd3c94703f1fa09324fe133fdd3d63b89561"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60a837f5936d1aa302458224bceed9532bc9864a5f7e45e0d50f589b54399e77"
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