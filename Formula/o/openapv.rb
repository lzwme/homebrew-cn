class Openapv < Formula
  desc "Open Advanced Professional Video Codec"
  homepage "https://github.com/AcademySoftwareFoundation/openapv"
  url "https://ghfast.top/https://github.com/AcademySoftwareFoundation/openapv/archive/refs/tags/v1.1.2.0.tar.gz"
  sha256 "970f65255896c906b22d7c9f9850deeee03fecf001415804848a03b6d1bbe41a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f6e9b637a312eea964ebec57891d85927a579fc5aee64aea740455ad6ed1a555"
    sha256 cellar: :any, arm64_tahoe:       "53f398dab107d600ca3570041729dcd3f577ff7c0d8e89029736b7051819c47c"
    sha256 cellar: :any, arm64_sequoia:     "51e10f9240d52c742b0d5fea31b0ebc6db072f23b62f3624d9418561391b5216"
    sha256 cellar: :any, arm64_linux:       "82b1668b0ea9a8caa105c3f112cc44b22ddf778b70047adf08084be54dce9489"
    sha256 cellar: :any, x86_64_linux:      "f50d27daad0758ae073a9208f08bc5d097f792b80d90135a80dfe764e4d5c90b"
  end

  depends_on "cmake" => :build

  allow_network_access! :test

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