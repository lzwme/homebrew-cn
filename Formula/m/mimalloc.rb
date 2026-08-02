class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://ghfast.top/https://github.com/microsoft/mimalloc/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "8ba991a7266983bd5eefc36e140c24734f720fd9b1fd79ddaeff44ea85d16760"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "040df2f87705fd1da4fd6277f8002ca96b338618f2dfa61c2485bb5b94c82727"
    sha256 cellar: :any, arm64_sequoia: "ca6934438cb70de811ed15a149bf316bf0e2bb0923a389ddce67a7895bb29068"
    sha256 cellar: :any, arm64_sonoma:  "a4ad6ba1bf661c19a9f9e6e9dfae3f3c63dac22244abafdcaf615a571e40500b"
    sha256 cellar: :any, sonoma:        "fce6a1abc99fe2ab14aa682e45b17f9f302374b727f6fdf91042a5475a5a3a77"
    sha256 cellar: :any, arm64_linux:   "a14d86eb75312f674a98e7661b0ab4d91eac6fdc9673e2eb3ba0c132a667bf18"
    sha256 cellar: :any, x86_64_linux:  "5506722e34a2151e7a749a8953f824004b96709c3c7a6a9dcd60623b67e527ad"
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