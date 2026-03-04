class VowpalWabbit < Formula
  desc "Online learning algorithm"
  homepage "https://github.com/VowpalWabbit/vowpal_wabbit"
  url "https://ghfast.top/https://github.com/VowpalWabbit/vowpal_wabbit/archive/refs/tags/9.11.1.tar.gz"
  sha256 "de404fc500fadec3195cd0a38094056571f1c8065c26e64df40b49ac643c8a8b"
  license "BSD-3-Clause"
  head "https://github.com/VowpalWabbit/vowpal_wabbit.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9bd0589d1b2682b7eb6fd9b89830b6bd780b2e3b3c68b24dd387657c03a70453"
    sha256 cellar: :any,                 arm64_sequoia: "faaee5a127239bdf71a7fae41429b3debdb23b9c7fade391a487ade189a31257"
    sha256 cellar: :any,                 arm64_sonoma:  "3647359849dd33874a2dc73c5093a187243f3cca0e288284435eaa158c6d5666"
    sha256 cellar: :any,                 sonoma:        "f2fec4927139cf65848148c7567ca03db85ffeb5d64311e39a63ffd46a398746"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df6bbda91aa1af735a2ba5f7bc330da7c0a7474fa57eb446b25b0aba3aba5f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ece7a125e69bd4edb477f5c6bda2e2cde024bc9d507dc76a6fd97fbd49cff952"
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