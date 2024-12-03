class Fatal < Formula
  desc "Facebook Template Library"
  homepage "https:www.facebook.comgroupslibfatal"
  url "https:github.comfacebookfatalreleasesdownloadv2024.12.02.00fatal-v2024.12.02.00.tar.gz"
  sha256 "ff291c2fb73e6ed30c2751551494b1c299cb6b84b52cea465eda92b57f3d63ef"
  license "BSD-3-Clause"
  head "https:github.comfacebookfatal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "84613d53d085b46c8303db0fe75deeba5f418c217f4329a6c870b03759a20f4c"
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