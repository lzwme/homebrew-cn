class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.19/ktexttemplate-6.19.0.tar.xz"
  sha256 "4087353ac20e376a3dce2ef49bc62f8856eb3b7933707faf62bb31b179c11c83"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "b2d35e96f9c0a41d36974af8833d8e42c0479197ec6cb0be81fa1bf02d377620"
    sha256 arm64_sequoia: "eada356c68908a80930dfda11dfa552d8f483065bba0e065a9abe24bc1198162"
    sha256 arm64_sonoma:  "b3bcd5ced2ca6846287ba05fb4dd92800518a12164c743b52696652a079ca60c"
    sha256 sonoma:        "5f6f76857e06b79e78e0f0779981f53d497cf5796ba7ee34a6f7fb30f111fa13"
    sha256 arm64_linux:   "925ca70020b5e6c56108492a2d9359458d9fd49f18be8087113cb8f89f1bd01f"
    sha256 x86_64_linux:  "173e0dfa7035414413bdad1190bb7ec5c65a0bf978a86de3accfe5ed13a4c300"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => :build
  depends_on "qttools" => :build
  depends_on "qtbase"
  depends_on "qtdeclarative"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    system "cmake", pkgshare/"examples/codegen", *std_cmake_args
    system "cmake", "--build", "."
  end
end