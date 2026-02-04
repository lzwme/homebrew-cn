class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://ghfast.top/https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.3.tar.gz"
  sha256 "d194fa587df807560be3ae75e123a97253dbc0736f26a41567668d64a23b6ec6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8c5210763a2f893c65972c8be64ed3210d5e22c2037b6aafb51f5e755b474124"
    sha256 cellar: :any,                 arm64_sequoia: "7427af0311d8b3b7f889e7c37a741a71bf79b7a43899166da0652e7337a48cf3"
    sha256 cellar: :any,                 arm64_sonoma:  "570017a83ed706ac41584d1263617924dc010aafa1e84fa596de5be5a3ad7594"
    sha256 cellar: :any,                 sonoma:        "3c09476da0f6cf699cd805ebc82787eaa2c2141b93edd5f2269fb2e6ba5a6365"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "831d5975519ba2d54adff28f6e38ea4e33d179e5552b5e61ba0fd5b2aea58750"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c66ea4bd5604c515aeab524cced417072e3e12b570a33372c341cdc172871bb"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", "Build/Cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "Testing/Calc/CameraModel.xml"
  end

  test do
    system bin/"iccFromXml", pkgshare/"CameraModel.xml", "output.icc"
    assert_path_exists testpath/"output.icc"

    system bin/"iccToXml", "output.icc", "output.xml"
    assert_path_exists testpath/"output.xml"
  end
end