class Fatal < Formula
  desc "Facebook Template Library"
  homepage "https:www.facebook.comgroupslibfatal"
  url "https:github.comfacebookfatalreleasesdownloadv2025.03.17.00fatal-v2025.03.17.00.tar.gz"
  sha256 "5d9e13011a8c08b6e0055caacafdc83947a728177240a5a47167bb15961f1b5b"
  license "BSD-3-Clause"
  head "https:github.comfacebookfatal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd838cfcafaeae09a0c5ac05ec707d496937512b3c9cae23c69f15d5a4fc818c"
  end

  def install
    rm "fatal.clang-tidy"
    include.install "fatal"
    pkgshare.install "demo", "lesson", *buildpath.glob("*.sh")
    inreplace "README.md" do |s|
      s.gsub!("(lesson)", "(sharefatallesson)")
      s.gsub!("(demo)", "(sharefataldemo)")
    end
  end

  test do
    system ENV.cxx, "-std=c++14", "-I#{include}",
                    include"fatalbenchmarktestbenchmark_test.cpp",
                    "-o", "benchmark_test"
    system ".benchmark_test"
  end
end