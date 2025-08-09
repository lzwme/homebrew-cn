class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/frameworks/ktexttemplate/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.17/ktexttemplate-6.17.0.tar.xz"
  sha256 "15d75941d15eac3cd1243066b13a30d6c1451ca630b0c29b3624be34ad73e972"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:  "033376fbc3dfd7f0c45ae069ea42e8dc9049725b56c6e67a9452e53b3784a217"
    sha256 arm64_ventura: "de6d4ec10bd3b4a136b972d7dcc07f3b1fb8e21bb3bf115ab9645d4fe7172d3d"
    sha256 sonoma:        "e524a91028c41043ae62d28f6d6537f5cc7a60b5af62a14c1c2ba7155d902d13"
    sha256 ventura:       "6ecae29de4b2ca00b2fda0fbefa2ee5c6c546f5b8bb6daa55fc8668d8f2942be"
    sha256 x86_64_linux:  "231bb080d95c0af99aa1ad8db7b105d04d95204a235478bf1661bbcc631a9979"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "extra-cmake-modules" => :build
  depends_on "qt"

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