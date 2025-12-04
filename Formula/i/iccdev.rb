class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://ghfast.top/https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.1.tar.gz"
  sha256 "de8750b0fbf9e3ec1e7260c0752427f54c9bb81b2f9366eaf75b7a7509d80097"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b2e46c66e480ec9a70b025d89844c5db91055d13f01b25d13d9755800edd631f"
    sha256 cellar: :any,                 arm64_sequoia: "90ea8470a294030b8b04b8824b28f0048599d0dae633427e5d090f532f9aff48"
    sha256 cellar: :any,                 arm64_sonoma:  "ba969c4f1b20223708114a944155cd4386618e5965edd805a4fd9be9f7ac43cc"
    sha256 cellar: :any,                 sonoma:        "a0bd33c510fc412600e8c3b02f0d861a44f1cbd53435b5ac6784063271c33bfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eb04e0083eed9bdfbf6fc94272d5a9e7ac1b0a4319251ac51e25e3940a68346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cf6fcda86a52a73d2897ca15ca72ede473c11661fb672f7f15038c098621226"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg"
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