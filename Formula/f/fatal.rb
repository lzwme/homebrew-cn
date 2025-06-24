class Fatal < Formula
  desc "Facebook Template Library"
  homepage "https:www.facebook.comgroupslibfatal"
  url "https:github.comfacebookfatalreleasesdownloadv2025.06.23.00fatal-v2025.06.23.00.tar.gz"
  sha256 "eb7e864e1b390715c0224d7c08cf8fde5710f1f07bb2f058aff58edee9d3e3af"
  license "BSD-3-Clause"
  head "https:github.comfacebookfatal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "41f61ff9e4d1875391de27c124b71fb00b593088f617c4a169a513cdc5dda118"
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