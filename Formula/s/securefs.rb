class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https:github.comnetheril96securefs"
  url "https:github.comnetheril96securefs.git",
      tag:      "0.14.3",
      revision: "8345530d700a6ff73ef59c5074403dede9f9ce96"
  license "MIT"
  revision 2
  head "https:github.comnetheril96securefs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4210df5259c83c830bb133d34b921e48004fc37585370382b5a750f354f317f9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "tclap" => :build
  depends_on "abseil"
  depends_on "argon2"
  depends_on "cryptopp"
  depends_on "jsoncpp"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "utf8proc"

  def install
    args = %w[
      -DSECUREFS_ENABLE_INTEGRATION_TEST=OFF
      -DSECUREFS_ENABLE_UNIT_TEST=OFF
      -DSECUREFS_USE_VCPKG=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}securefs", "version" # The sandbox prevents a more thorough test
  end
end