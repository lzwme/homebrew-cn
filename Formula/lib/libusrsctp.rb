class Libusrsctp < Formula
  desc "Portable SCTP userland stack"
  homepage "https://github.com/sctplab/usrsctp"
  url "https://ghproxy.com/https://github.com/sctplab/usrsctp/archive/0.9.5.0.tar.gz"
  sha256 "260107caf318650a57a8caa593550e39bca6943e93f970c80d6c17e59d62cd92"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/sctplab/usrsctp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "27f59644b7711afcde95e34c6258a4f62bedaff91e7de90356494a511fa85f35"
    sha256 cellar: :any,                 arm64_monterey: "5aebfe223f88de1bd4b8177d85a4034f819c9957f2f56292e8961ea52af1f20c"
    sha256 cellar: :any,                 arm64_big_sur:  "55d87963abae2a23d3f13644ce478a08c05a929a5619ff5d3db24c3758873520"
    sha256 cellar: :any,                 ventura:        "a99c35127a48fb9bfbd02e75741938b4bfe4f7ada7c53692fc944e2a316fa72a"
    sha256 cellar: :any,                 monterey:       "574a2ddedf60e11662a1ba899019334390bcc5b3ef8a789fe9feec7f32974b77"
    sha256 cellar: :any,                 big_sur:        "8c7e338e82252ed7aa5ac2ac8d007f70d998d428dd713a1bc9e57fa7c483d004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ed390a46abf6f2244181acd53fafe4280a4b0f41e07720e3161d27995b0cbff"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-Dsctp_build_shared_lib=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <unistd.h>
      #include <usrsctp.h>
      int main() {
        usrsctp_init(0, NULL, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lusrsctp", "-lpthread", "-o", "test"
    system "./test"
  end
end