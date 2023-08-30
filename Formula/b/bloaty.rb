class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://ghproxy.com/https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 14

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e0153c34dbba1b0daf6abf130964306eebe86cfdfef0e8082281f3ba43a5d617"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea7cb70d93f02c96454aca33c247170fc00ea420cf157a57422959c55eafce81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de74c76cb4045e2c8bc61ff606e51cd6d58b3d91d49c50ac019855de8385aee7"
    sha256 cellar: :any_skip_relocation, ventura:        "b2ec20e23e1cd94435f2c16e8760ba28cf04f892ad9f0b79d0c8b8db6663f707"
    sha256 cellar: :any_skip_relocation, monterey:       "db78482de189eb58e185fd6ab9f44ee9d20e75c7f915df65652b22649353bbba"
    sha256 cellar: :any_skip_relocation, big_sur:        "66e5512c1cf890216ef44cb604fbc646ecf573cfcf108d110c102d7e9d7e2fcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b49a1e4ac0ec608154c076b595539b9b0054626257525d2416bf1549dd01e6a"
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