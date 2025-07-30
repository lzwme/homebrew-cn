class Fatal < Formula
  desc "Facebook Template Library"
  homepage "https://www.facebook.com/groups/libfatal/"
  url "https://ghfast.top/https://github.com/facebook/fatal/releases/download/v2025.07.28.00/fatal-v2025.07.28.00.tar.gz"
  sha256 "81854ccb9ce041d511f3123b5ce0b64fc24cedeb37ae2d337a4ad20d61b40c1d"
  license "BSD-3-Clause"
  head "https://github.com/facebook/fatal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5013297dce9042041689e2af5740f1595f7a6d6a500e087dea00118fee0289c0"
  end

  def install
    rm "fatal/.clang-tidy"
    include.install "fatal"
    pkgshare.install "demo", "lesson", *buildpath.glob("*.sh")
    inreplace "README.md" do |s|
      s.gsub!("(lesson/)", "(share/fatal/lesson/)")
      s.gsub!("(demo/)", "(share/fatal/demo/)")
    end
  end

  test do
    system ENV.cxx, "-std=c++14", "-I#{include}",
                    include/"fatal/benchmark/test/benchmark_test.cpp",
                    "-o", "benchmark_test"
    system "./benchmark_test"
  end
end