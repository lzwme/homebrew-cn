class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.10.3.tar.gz"
  sha256 "97fde3cf05129db919453af4ef6c6a415662111c2e6e9b5194e2566d44b8507a"
  license "MIT"
  head "https://github.com/capnproto/capnproto.git", branch: "master"

  livecheck do
    url "https://capnproto.org/install.html"
    regex(/href=.*?capnproto-c\+\+[._-]v?(\d+(\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "831fcdfa557c7e962d811726d9eb22facad34d5003a20f79d2936a01049f8955"
    sha256 arm64_monterey: "55105a23644cbfe3e53c018806f84c8244bbf4cbd4c63e60950b454c0db59268"
    sha256 arm64_big_sur:  "46e6d74f3a6b9ceb2ddb219078ab0f7bd62097bc154a7ec9b27a5f468b2d5971"
    sha256 ventura:        "7c08e2fd9633d20e7fad069de568fbe7c0ee02a945a1afac4411418205f2d0d7"
    sha256 monterey:       "952af596ab4e105f463da3c2ba52f11ec6326e3d86368627ef1357913ee1e098"
    sha256 big_sur:        "655f9e9b27776c029f810887af2fd588661bd8191b9dfcd03b7d5143cd26cc81"
    sha256 x86_64_linux:   "d73d87cba3ba4fd1a9ba325b252b8e9598f52b3f3bca19bb249725f34dec3928"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    file = testpath/"test.capnp"
    text = "\"Is a happy little duck\""

    file.write shell_output("#{bin}/capnp id").chomp + ";\n"
    file.append_lines "const dave :Text = #{text};"
    assert_match text, shell_output("#{bin}/capnp eval #{file} dave")
  end
end