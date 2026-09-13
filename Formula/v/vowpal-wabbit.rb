class VowpalWabbit < Formula
  desc "Online learning algorithm"
  homepage "https://vowpalwabbit.org"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/VowpalWabbit/vowpal_wabbit.git", branch: "master"

  stable do
    url "https://ghfast.top/https://github.com/VowpalWabbit/vowpal_wabbit/archive/refs/tags/9.11.2.tar.gz"
    sha256 "21352230bf0e4c01fb4da1959a7338e21a3150ca5641eb2328abfc749fd32e77"

    # fmt 12.2 removed fmt::format from <fmt/core.h>.
    patch do
      url "https://github.com/VowpalWabbit/vowpal_wabbit/commit/5f3aecba8f6caf252d3b1f5765ef470460638d19.patch?full_index=1"
      sha256 "56313024992c4a4cd8ebdca09ecd50298bce48eb43aefd8cfe60003b1da4a34d"
      type :backport
      resolves "https://github.com/VowpalWabbit/vowpal_wabbit/pull/4922"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "5044866ccd2a37958ae1dcf7e92fd28c8e80a995ebdc4ac220dd0421e4fc0f45"
    sha256 cellar: :any, arm64_tahoe:       "06c6aa41afc3beb526bdc2e424c69ce5c4a143d158885d87dc366dea6279d079"
    sha256 cellar: :any, arm64_sequoia:     "ccece3ff0e46959b4735c4f309f6f89dc30305f7665fd5e44c1ee4f6c47b779e"
    sha256 cellar: :any, arm64_linux:       "a7035c3e87f8e27bc86f474a71133245f974e0196c46fb12e3db877c57b43747"
    sha256 cellar: :any, x86_64_linux:      "53e5278d9a14ab90b7f838baa74c6de0f965601df4757736ead9c70d5a47d1ac"
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