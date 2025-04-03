class Unshield < Formula
  desc "Extract files from InstallShield cabinet files"
  homepage "https:github.comtwogoodunshield"
  url "https:github.comtwogoodunshieldarchiverefstags1.6.1.tar.gz"
  sha256 "3f477d177e5ab805d41e5d06bb8cc42540769dd937ddc78e2e07f9f853034d66"
  license "MIT"
  head "https:github.comtwogoodunshield.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2716f4510a0bcf25949c1ff30193b044ed8edf2d7e0278c308e83e6a1d2c550a"
    sha256 cellar: :any,                 arm64_sonoma:  "8d018ee21d434988c240a612e51e4f22e1a09b0a61a8fe919045bee74d4b77de"
    sha256 cellar: :any,                 arm64_ventura: "84b33c02f822f1f1f4bb575ff0e43287d21a4917f674cdda2a5ed69c77790bd6"
    sha256 cellar: :any,                 sonoma:        "efa2679c5b20f815d4abb7a5a15a9aab501667f283393cda757a0deeefa8655e"
    sha256 cellar: :any,                 ventura:       "da3d491cf636f1fc2700153afa071c9e0ea2c7c71a39ca54983314d834f75a9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b49f8eef9fe14dc07089157279a8d8c7d835f9e64ba248a179a705736becd1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d6b7ca84cf02a29f111ab6ce8c3b4519dd3d81b2d296c565372c35dbdd30307"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    # cmake check for libiconv will miss the OS library without this hint
    ENV.append "LDFLAGS", "-liconv" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DUSE_OUR_OWN_MD5=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin"unshield", "-e", "sjis", "-V"
  end
end