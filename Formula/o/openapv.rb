class Openapv < Formula
  desc "Open Advanced Professional Video Codec"
  homepage "https://github.com/AcademySoftwareFoundation/openapv"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openapv/archive/refs/tags/v0.2.1.0.tar.gz"
  sha256 "60da432ba2727d5ec7bcf7f2d251eecdec14ced31e07deddb584b38719a691d5"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f6cac7ea29cfb653a50ab6926d2a74d8cbd0ee4e4f1aacf7f22316020faed722"
    sha256 cellar: :any,                 arm64_sequoia: "28190c26f6a8241d3f75606bef0113710f085797f20707c73a375957232bdf20"
    sha256 cellar: :any,                 arm64_sonoma:  "c9550db5a4894a4823a38f4ff1fabd5a873a3eb1fbf2ace282330ff55b4d995d"
    sha256 cellar: :any,                 sonoma:        "76fb3305b9beb9b93866ecf26029c35e6e01c72bbb6edc06ff6a9c9519f9699d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea15079f40204998267c142b301cf889e26179328005c9751a6e79a165507010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c4dac2715c16ada32ebb1be8df2bd28c27a3b09ee05311e4cfa82be9dcc9633"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DOAPV_APP_STATIC_BUILD=OFF",
           "-DCMAKE_INSTALL_RPATH=#{rpath}",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test_video" do
      url "https://ghfast.top/https://raw.githubusercontent.com/fraunhoferhhi/vvenc/master/test/data/RTn23_80x44p15_f15.yuv"
      sha256 "ecd2ef466dd2975f4facc889e0ca128a6bea6645df61493a96d8e7763b6f3ae9"
    end

    resource("homebrew-test_video").stage testpath

    system bin/"oapv_app_enc", "-i", "RTn23_80x44p15_f15.yuv",
           "--input-csp", "2", "--width", "80", "--height", "44", "--fps", "15",
           "-o", "encoded.apv"
    assert_path_exists testpath/"encoded.apv"

    system bin/"oapv_app_dec", "-i", "encoded.apv", "-o", "decoded.y4m"
    assert_path_exists testpath/"decoded.y4m"
  end
end