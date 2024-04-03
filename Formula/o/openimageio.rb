class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https:openimageio.readthedocs.ioenstable"
  url "https:github.comAcademySoftwareFoundationOpenImageIOarchiverefstagsv2.5.10.1.tar.gz"
  sha256 "8f6a547f6a5d510737ba436f867043db537def65f0fdb14ec30e5a185b619f93"
  license "Apache-2.0"
  head "https:github.comAcademySoftwareFoundationOpenImageIO.git", branch: "master"

  livecheck do
    url :stable
    regex((?:Release[._-])?v?(\d+(?:\.\d+)+)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e16275f1030520176e44e912dbd0a3a71560e18a9f4b91a9b472e4249795f7c9"
    sha256 cellar: :any,                 arm64_ventura:  "7e9fb99abb92bcae23f22b47cf3fd167a06a2e0929080e9f96dd0c7e48a01aba"
    sha256 cellar: :any,                 arm64_monterey: "f05a6ccefccab7cb567292de27e02464f3e161164997d6e7d318446d4b8ae53c"
    sha256 cellar: :any,                 sonoma:         "b187389734f3acdf80732915bd075e98caa80c9ccfb4317c34108967c7d7fa7d"
    sha256 cellar: :any,                 ventura:        "f1d5d1ba2407d2d9948de4d6458073afb4da5498f2b6b888c0e35f0a63ffe41b"
    sha256 cellar: :any,                 monterey:       "556bee2e5401490ad095be14a8c86a16eff1ca142d70718b624990fe5e27834b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4243a32a3893612725d4c7feb01f0c97cfce09d01b55a7ee792593f74b3e5ae5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "ffmpeg"
  depends_on "fmt"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "imath"
  depends_on "jpeg-turbo"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "pugixml"
  depends_on "pybind11"
  depends_on "python@3.12"
  depends_on "webp"

  # https:github.comAcademySoftwareFoundationOpenImageIOblobmasterINSTALL.md
  fails_with :gcc do
    version "5"
    cause "Requires GCC 6.1 or later"
  end

  def python3
    "python3.12"
  end

  def install
    py3ver = Language::Python.major_minor_version python3
    ENV["PYTHONPATH"] = prefixLanguage::Python.site_packages(python3)

    args = %W[
      -DPython_EXECUTABLE=#{which(python3)}
      -DPYTHON_VERSION=#{py3ver}
      -DBUILD_MISSING_FMT=OFF
      -DCCACHE_FOUND=
      -DEMBEDPLUGINS=ON
      -DOIIO_BUILD_TESTS=OFF
      -DUSE_DCMTK=OFF
      -DUSE_EXTERNAL_PUGIXML=ON
      -DUSE_JPEGTURBO=ON
      -DUSE_NUKE=OFF
      -DUSE_OPENCV=OFF
      -DUSE_OPENGL=OFF
      -DUSE_OPENJPEG=OFF
      -DUSE_PTEX=OFF
      -DUSE_QT=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "#{test_image} :    1 x    1, 3 channel, uint8 jpeg",
                 shell_output("#{bin}oiiotool --info #{test_image} 2>&1")

    output = <<~EOS
      from __future__ import print_function
      import OpenImageIO
      print(OpenImageIO.VERSION_STRING)
    EOS
    assert_match version.major_minor_patch.to_s, pipe_output(python3, output, 0)
  end
end