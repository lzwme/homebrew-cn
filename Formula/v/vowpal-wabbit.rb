class VowpalWabbit < Formula
  desc "Online learning algorithm"
  homepage "https://github.com/VowpalWabbit/vowpal_wabbit"
  url "https://ghfast.top/https://github.com/VowpalWabbit/vowpal_wabbit/archive/refs/tags/9.11.0.tar.gz"
  sha256 "ccf3810413bcf35314ebfacced3e2186b05d9d8fa6e4dfa9d2ef34ed7d9b50a5"
  license "BSD-3-Clause"
  head "https://github.com/VowpalWabbit/vowpal_wabbit.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e2ff8f22307a79867dd56be776acf475b456cfbf8482f84171101dc8c77715f4"
    sha256 cellar: :any,                 arm64_sequoia: "7664e0852d72f41c2b654ff0d404b41311b0bd10d3ace4a809b63e00f5ef7910"
    sha256 cellar: :any,                 arm64_sonoma:  "a455448d067774b0b9a88796635b8c324818d7563f81e4fe1a6af64c4ab51050"
    sha256 cellar: :any,                 sonoma:        "79823d664081e3df84177e2862661288636bf611f113c1ec920276100f8675c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04d0763c7cbf9fda0076e8c0984900cb037c108d0e55a5ca02c9c7cf8038bba9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50b384ea12769e4fb6d23f37416387d9fbbbe46a90ca0bf190152403657196dc"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "eigen" => :build
  depends_on "rapidjson" => :build
  depends_on "spdlog" => :build
  depends_on "fmt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  on_arm do
    depends_on "sse2neon" => :build
  end

  # Fix system RapidJSON packages that export include dirs but no CMake target.
  # Upstream PR ref: https://github.com/VowpalWabbit/vowpal_wabbit/pull/4902
  patch do
    url "https://github.com/VowpalWabbit/vowpal_wabbit/commit/887a1fdf2d3443b615bd8b4d066518eb84fbb693.patch?full_index=1"
    sha256 "1204402159a276d31f0883dbdb3191ad6e5e084dcf90e7d8cd3d349c89f70ef5"
  end

  def install
    args = %w[
      -DRAPIDJSON_SYS_DEP=ON
      -DFMT_SYS_DEP=ON
      -DSPDLOG_SYS_DEP=ON
      -DVW_BOOST_MATH_SYS_DEP=ON
      -DVW_EIGEN_SYS_DEP=ON
      -DVW_SSE2NEON_SYS_DEP=ON
      -DVW_INSTALL=ON
      -DVW_CXX_STANDARD=14
    ]

    # The project provides a Makefile, but it is a basic wrapper around cmake
    # that does not accept *std_cmake_args.
    # The following should be equivalent, while supporting Homebrew's standard args.
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.install Dir["utl/*"]
    rm bin/"active_interactor.py"
    rm bin/"vw-validate.html"
    rm bin/"clang-format.sh"
    rm bin/"release_blog_post_template.md"
    rm_r bin/"flatbuffer"
    rm_r bin/"dump_options"
  end

  test do
    (testpath/"house_dataset").write <<~EOS
      0 | price:.23 sqft:.25 age:.05 2006
      1 2 'second_house | price:.18 sqft:.15 age:.35 1976
      0 1 0.5 'third_house | price:.53 sqft:.32 age:.87 1924
    EOS
    system bin/"vw", "house_dataset", "-l", "10", "-c", "--passes", "25", "--holdout_off",
                     "--audit", "-f", "house.model", "--nn", "5"
    system bin/"vw", "-t", "-i", "house.model", "-d", "house_dataset", "-p", "house.predict"

    (testpath/"csoaa.dat").write <<~EOS
      1:1.0 a1_expect_1| a
      2:1.0 b1_expect_2| b
      3:1.0 c1_expect_3| c
      1:2.0 2:1.0 ab1_expect_2| a b
      2:1.0 3:3.0 bc1_expect_2| b c
      1:3.0 3:1.0 ac1_expect_3| a c
      2:3.0 d1_expect_2| d
    EOS
    system bin/"vw", "--csoaa", "3", "csoaa.dat", "-f", "csoaa.model"
    system bin/"vw", "-t", "-i", "csoaa.model", "-d", "csoaa.dat", "-p", "csoaa.predict"

    (testpath/"ect.dat").write <<~EOS
      1 ex1| a
      2 ex2| a b
      3 ex3| c d e
      2 ex4| b a
      1 ex5| f g
    EOS
    system bin/"vw", "--ect", "3", "-d", "ect.dat", "-f", "ect.model"
    system bin/"vw", "-t", "-i", "ect.model", "-d", "ect.dat", "-p", "ect.predict"

    (testpath/"train.dat").write <<~EOS
      1:2:0.4 | a c
        3:0.5:0.2 | b d
        4:1.2:0.5 | a b c
        2:1:0.3 | b c
        3:1.5:0.7 | a d
    EOS
    (testpath/"test.dat").write <<~EOS
      1:2 3:5 4:1:0.6 | a c d
      1:0.5 2:1:0.4 3:2 4:1.5 | c d
    EOS
    system bin/"vw", "-d", "train.dat", "--cb", "4", "-f", "cb.model"
    system bin/"vw", "-t", "-i", "cb.model", "-d", "test.dat", "-p", "cb.predict"
  end
end