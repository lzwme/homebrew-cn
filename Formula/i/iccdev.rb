class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://ghfast.top/https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.3.1.4.tar.gz"
  sha256 "7889fd4544e1d224700aa68659a83847b24a8adaa130db1d64e8577098b8700a"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "512cc2ef21bcf40910b09257ee0fa9160cc783da05b4d4054635e4962e433b4a"
    sha256 cellar: :any,                 arm64_sequoia: "087929b684f50466c2904de9831675dbe073973d082704d485509345c318f9a8"
    sha256 cellar: :any,                 arm64_sonoma:  "727c9e6edef0bc6f3a48078aad30683f05c9f4eff21f6b0a4b6a39bf79ff0bd2"
    sha256 cellar: :any,                 sonoma:        "14a7bd885e583a20db5d9277750be36d173fcd3d604061cfeb4be136019955f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f754aa2086576c3a0d66df64db78c0762370492490efcb451d4382b7528e6d25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c6075c1c8907b1f0c37a8e313e1d54341122a7f9ec94e501a37f7f50b377006"
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