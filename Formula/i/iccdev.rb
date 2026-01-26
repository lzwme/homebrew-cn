class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://ghfast.top/https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.2.tar.gz"
  sha256 "c2de941c493af4a01f89369d297528e649df38b2e270c29f7b04d245b63bc4bd"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0981b4776b7117aac0685a4cdfad2447e20766318e2d9153b29ea06a32583703"
    sha256 cellar: :any,                 arm64_sequoia: "a35b1999eb2da3a9508e5a7ac61084b7b4eb2aa6f89fa36918ea6848bd747a2c"
    sha256 cellar: :any,                 arm64_sonoma:  "bde2eb199ab540c9fcd285edd9837e638796fae74176d3b3bd41c96c1d3bbe8b"
    sha256 cellar: :any,                 sonoma:        "01add9e1aaeb8de975111dafc6915c8c903e9361f1d368701c6e62afd4a0f5ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "534fa0f5ed3eebd07fcefba662c0d06b779d53a23597fcb83daeb93b16961a0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58ab695a537b383d3d429aa01e460abb0546703f3eafc10bf63d8d32b0e673db"
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