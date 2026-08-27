class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https://nng.nanomsg.org/"
  url "https://ghfast.top/https://github.com/nanomsg/nng/archive/refs/tags/v1.12.3.tar.gz"
  sha256 "036a925790034efdeef8a6803f3e4402c3ab509383326f8bc2f15ecee75a2fa2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3999f02eb6198bec7b30e725b6b7e44130a605adbea8a5aeb85735cf9d0a1025"
    sha256 cellar: :any, arm64_sequoia: "b9f61f429e7193276bba54c523779c0178eb6d21c386c2868580f3643b0d3ad5"
    sha256 cellar: :any, arm64_sonoma:  "d4c8f20d5f9f5f35ab1020f5ee7e5d669584c1f9809d6af04993bc4e2a45485b"
    sha256 cellar: :any, sonoma:        "689c87dece9e5d14e95bd8a423c8762b28876e7f293f1b6646ff45735babc6ee"
    sha256 cellar: :any, arm64_linux:   "c843c0b48a31b79acd86c2849b7f36caab86aa839c67987cd833ffa7fa9ee3f0"
    sha256 cellar: :any, x86_64_linux:  "20fb8f08beadd1e627363437fb5cf7a7ac30c729030d29b77f04d6c3e67175bf"
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