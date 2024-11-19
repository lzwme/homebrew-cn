class Fatal < Formula
  desc "Facebook Template Library"
  homepage "https:www.facebook.comgroupslibfatal"
  url "https:github.comfacebookfatalreleasesdownloadv2024.11.18.00fatal-v2024.11.18.00.tar.gz"
  sha256 "7fdc4393bbefe00ca91ea824a9fb93dcecd014c2fc26ce9f046a228617401f67"
  license "BSD-3-Clause"
  head "https:github.comfacebookfatal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9d4178e020a990ab7021c40b1888ea174c9e38e269eea13cf8c2d2494df10fdd"
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