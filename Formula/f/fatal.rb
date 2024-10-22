class Fatal < Formula
  desc "Facebook Template Library"
  homepage "https:www.facebook.comgroupslibfatal"
  url "https:github.comfacebookfatalreleasesdownloadv2024.10.21.00fatal-v2024.10.21.00.tar.gz"
  sha256 "4350a2923dba48f65ba5b6ff7c3e8c7319015d2c052a335c25ecd7b821124a29"
  license "BSD-3-Clause"
  head "https:github.comfacebookfatal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "da7618ebf39397e800e31bf654f962107deaf8845b1e7e456806b66a02bbdf77"
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