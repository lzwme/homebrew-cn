class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://ghfast.top/https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.6.tar.gz"
  sha256 "ee89402db8f4e5a6cd732dca6f16545cc16bd14590b1d7b191ff593e5cbb87a6"
  license "BSD-3-Clause"

  # Skip `wasm-` tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "163abab7e37c33a5f15f6c507c45d60602534f5ea40dcc28021eab8c1f7c2687"
    sha256 cellar: :any,                 arm64_sequoia: "e89b52a2489e628a00fda054193845d197f52bb45a89362f93902a5753d47f18"
    sha256 cellar: :any,                 arm64_sonoma:  "f584467504056635de65645dc44cabf7e3cd037dd8e654342e9fd080a819a405"
    sha256 cellar: :any,                 sonoma:        "f0fe6a53ac27e661113ff7574bfc57ecbf7cef57ce5b5d1faf0cc841ad528681"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c53c81d947cfe9ec5a47a478f69b77734636e2ad0fcb9406c1a5e7e917f6f120"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f628fbbb8fbbf5f8219ffc3e189457e780e05a4f2101c4ba64df23ff98636e79"
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