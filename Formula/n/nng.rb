class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https:nanomsg.github.ionng"
  url "https:github.comnanomsgnngarchiverefstagsv1.7.1.tar.gz"
  sha256 "b62b2170d2b4757f9f01fb65e5aa9f078dec726735e9de5ed5d7e332cbbbf2ef"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ab70fd5f47ba87f3ebacdab9007260018e38a9bcf26491a37e1e00c02ec6930b"
    sha256 cellar: :any,                 arm64_ventura:  "3cf78bc2d7d607ffba2385275a6961d2ea065978a401570982d6a8c25187b696"
    sha256 cellar: :any,                 arm64_monterey: "3086eb090d9c55fce3f4f81c6f1813e42173d1caf735c6a94c9a217d71c3c386"
    sha256 cellar: :any,                 sonoma:         "5aead104173f4bfe232798ec9a9f539f423563f5e0d749f152a98d6219b1f748"
    sha256 cellar: :any,                 ventura:        "5823aba4ee3a8d306821df543f3f5d4be82f6fb5611699bcd3bc8eb9a7577b5f"
    sha256 cellar: :any,                 monterey:       "d7133872ed1468afa0c6022b456cbf4fa8bc0a05aea8453c359118d040a394ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c82a2fb5c4c1006750a282b9d2eabb86f17a6d2f101a62e9de3680c48b00465"
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
    bind = "tcp:127.0.0.1:#{free_port}"

    fork do
      exec "#{bin}nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    output = shell_output("#{bin}nngcat --req --connect #{bind} --format ascii --data brew")
    assert_match(home, output)
  end
end