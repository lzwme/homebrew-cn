class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.18/ktexttemplate-6.18.0.tar.xz"
  sha256 "cbb6505c35a8edc0e6fefb7d24fde8275eefdc9735407297ace02a7c40f37e06"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "0757f0d257346e5f0e30cd4a698b833249b1d31c010aa0d1dbd354aa1f4fdc31"
    sha256 arm64_sequoia: "16a7c4d88597cf60dd5ee1109692e724045db60a99ca49fe9c588f9d9881e8a2"
    sha256 arm64_sonoma:  "699094da7427ce13fdf7dde43cc15cc62ddec702ee5083516f50e9d53c6cf8cd"
    sha256 sonoma:        "b533dc2c50b3c4d106af41e5a77287338c497a429174e1baf859ff7fd029c85d"
    sha256 x86_64_linux:  "1926a611b6227a8e72db78e2f7f4a09c44aec111230581a69b9d98002b853130"
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