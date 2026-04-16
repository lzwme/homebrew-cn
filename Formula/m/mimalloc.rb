class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://ghfast.top/https://github.com/microsoft/mimalloc/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "cf227295c307efc6f16e90c485595f9bb91c5a5532a3000f81f08907f8fc56a2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4616013e772f0cd0c0fa4358aef3341c8eaa54ae595e24e594e2bef91809f180"
    sha256 cellar: :any,                 arm64_sequoia: "ef70ef3afd490318ba382126ce1c4b636d7b8b30c313a272edd560cb0a9843c7"
    sha256 cellar: :any,                 arm64_sonoma:  "8c749c7fdf0f125d47e104f24a659c112bea8103a85b99bab801e5829031f6e5"
    sha256 cellar: :any,                 sonoma:        "2a5ca969c4d70e4277eab183ac9fb31247277826d07fc58d83c65f020c90562f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b60fe99a08e2cddd4cdc98d3040fcfba9972541ec8698c1d5f9331b675bc2e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be04ba3bb87362beded8351ee96fcb02e75bf3ddac3bf4948237b9243be80bf3"
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