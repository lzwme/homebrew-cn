class Iccdev < Formula
  desc "Demonstration Implementation for iccMAX color profiles"
  homepage "https://github.com/InternationalColorConsortium/DemoIccMAX"
  url "https://ghfast.top/https://github.com/InternationalColorConsortium/DemoIccMAX/archive/refs/tags/v2.2.50.tar.gz"
  sha256 "f48fc2e3f4cc80f9c73df27bf48fca3de7d0a81266d7084df544941e61b37eb2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f722a5bbdb050d4c8fc3a98ddb44ee416bf5b3dcef1ff97a7a4d7337c78e3626"
    sha256 cellar: :any,                 arm64_sonoma:  "cbf8e8773fb606ad43f4eeef01be4531b03e8671a200fc930d16269184b1cfed"
    sha256 cellar: :any,                 arm64_ventura: "320314d7aa7f677efe22cdc29b815205c4a8e44acc41bf2e269f2e7f49182d03"
    sha256 cellar: :any,                 sonoma:        "7d8888b48a3fabea1b4b425ce45c0022cfe1aefab7ef197fc96af928027f2cbc"
    sha256 cellar: :any,                 ventura:       "19822d5ff8e4213013e005cf41b52046c2822b2ecafc08f6da0109bba4b45e08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d6dd04ecdae3a0fee2746b33a1453f949b519278d1335ae4eb533d583ab5c621"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1096b2b99784ab6d08d1590ab5f3dcd3f2b9145429b97c4e5182328a85877145"
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
      -DENABLE_TOOLS=ON
      -DENABLE_SHARED_LIBS=ON
      -DENABLE_INSTALL_RIM=ON
      -DENABLE_ICCXML=ON
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