class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://ghfast.top/https://github.com/microsoft/mimalloc/archive/refs/tags/v3.4.5.tar.gz"
  sha256 "19a43af0645c57d348e729d5b31e23e912582911bb1047f795790834d3416221"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9077f37fc69371fd4008e58fb15e06bb8c0b1b998a6094990d16f44200db6641"
    sha256 cellar: :any, arm64_sequoia: "15c7d3d56601a87279eea7c4686e77a58ce66ef6a376102e6baa8b1e62a3b7c3"
    sha256 cellar: :any, arm64_sonoma:  "1678fd475e2e6c3606450c0bf42e5911d09c7391d801bcfdb1569a127908acbf"
    sha256 cellar: :any, sonoma:        "4b45d88e9d98dbff5d8e0c8f84dccd488eddc1f13c756b74aef21d1c15932149"
    sha256 cellar: :any, arm64_linux:   "88fa2078409d0603aa18579865da7bd90febae4b94366963037a478a61703f91"
    sha256 cellar: :any, x86_64_linux:  "5f71335fcda0a35cb1653f390e3b501763647ec3bad2e50671c77c3516dfcca9"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match(/pages\s+peak\s+total\s+current\s+block\s+total/, shell_output("./test 2>&1"))
  end
end