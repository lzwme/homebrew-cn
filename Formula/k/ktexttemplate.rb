class Ktexttemplate < Formula
  desc "Libraries for text templating with Qt"
  homepage "https://api.kde.org/ktexttemplate-index.html"
  url "https://download.kde.org/stable/frameworks/6.21/ktexttemplate-6.21.0.tar.xz"
  sha256 "864667da2190a3cdd429269d9303357ebfeb3c4c34cb651071d482c56f8b772d"
  license "LGPL-2.1-or-later"
  head "https://invent.kde.org/frameworks/ktexttemplate.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "c6ebf8f0de4cf8c595263a03443669899980e2251bc7e67fc2f35f903680d876"
    sha256 arm64_sequoia: "90cfffa8e30f9ad3d3dffdf22f0436d3c4d8cfc91566fd0853907bba43b42ac2"
    sha256 arm64_sonoma:  "63c8849b7401e2421ee0441becaa2c040ecce94be7700712d02a2717fa442c1e"
    sha256 sonoma:        "490288730b45924dd0c4243bb3550b032776ce54bebcf52e85c1929558105528"
    sha256 arm64_linux:   "d77abe672ba0405a3a25eef8f6bff467e0732bc028739fdf3fe999097158c78d"
    sha256 x86_64_linux:  "76ada5a981648ded28d724e9c531c6f544a13852a4be39c2dbe74dff27375909"
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