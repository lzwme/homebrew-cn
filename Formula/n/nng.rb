class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nanomsg.github.io/nng/"
  url "https://ghproxy.com/https://github.com/nanomsg/nng/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "f639e77911ef935a13e9779d4a18d45490433ba744f89752a15b84c929ce2725"
  license "MIT"

  livecheck do
    url "https://github.com/nanomsg/nng.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "198872a781734b72b80d9c9fc86452bda241937bb94fd4b68d3f912e516c92bf"
    sha256 cellar: :any,                 arm64_ventura:  "3a4ee22384fe27c11679b209e5873464cab1c52ab8012d38e94da2f2e47145ba"
    sha256 cellar: :any,                 arm64_monterey: "f62435fa8227213cef6c368feb1a73ead1fc76bf64f3cd6bb25928a6ce7cb208"
    sha256 cellar: :any,                 sonoma:         "619951daedbba3569bfadd0543357b25a05a89cedf3db1ec3051013ab0e80d66"
    sha256 cellar: :any,                 ventura:        "c56dcd5b58a0eb88d19ef4842c473458f313bfe1059e36fe56f5ef8cc96e3fee"
    sha256 cellar: :any,                 monterey:       "d8ce930facddca708309844ff020de593050fd9a718ebf12ee4d6347931bab75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06b27dfe40cf5d01375a5710aae2d2347ede630223c5d32ef9bd378d1744be2f"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DNNG_ENABLE_DOC=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    bind = "tcp://127.0.0.1:#{free_port}"

    fork do
      exec "#{bin}/nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    output = shell_output("#{bin}/nngcat --req --connect #{bind} --format ascii --data brew")
    assert_match(/home/, output)
  end
end