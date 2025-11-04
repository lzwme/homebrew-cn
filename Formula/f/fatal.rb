class Fatal < Formula
  desc "Facebook Template Library"
  homepage "https://www.facebook.com/groups/libfatal/"
  url "https://ghfast.top/https://github.com/facebook/fatal/releases/download/v2025.11.03.00/fatal-v2025.11.03.00.tar.gz"
  sha256 "8bbdca046f0d060787e485348ac750615ee6562ee486d486b6612c3a4552a4c1"
  license "BSD-3-Clause"
  head "https://github.com/facebook/fatal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b874bd25eee650a99d79d32b2533b04c0fe0ac4fe30fed14a5b6ba0027505ed7"
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