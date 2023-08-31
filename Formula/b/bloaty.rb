class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://ghproxy.com/https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 15

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8be3229b83c8db36aeb0ea2edb1ffa1e76f6e04d7a38af04d47eacb18883357"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c65d1c14031235a96213c62ed52b51ee46b98c32f3947a867a989dbd685b500f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d161eb96605eeb6a772d77961ac842812436b78a91e7f209c16d597b72ca4a9e"
    sha256 cellar: :any_skip_relocation, ventura:        "f6046ce6c90ed9312bf13e957bb3a4b5ec3a23b323aacfa2e30cc1fe2666a1b9"
    sha256 cellar: :any_skip_relocation, monterey:       "17da424e8f19cf1149f5bdd6b26d1dc12faf8e10400d71f1cbd3a8a8b7016a03"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f114b5998fe7271896a8d143402f475bf391d734a278220044ea1bcbbfd4431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d9af7581cad27f5e3b94ec4048deb9ded92b1342f7031e7ae4e2259076b461a"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  # Support system Abseil. Needed for Protobuf 22+.
  # Backport of: https://github.com/google/bloaty/pull/347
  patch do
    url "https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/formula-patches/86c6fb2837e5b96e073e1ee5a51172131d2612d9/bloaty/system-abseil.patch"
    sha256 "d200e08c96985539795e13d69673ba48deadfb61a262bdf49a226863c65525a7"
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    # Remove vendored dependencies
    %w[abseil-cpp capstone protobuf re2].each { |dir| (buildpath/"third_party"/dir).rmtree }
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last)
  end
end