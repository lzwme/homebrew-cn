class Clifm < Formula
  desc "Command-line Interface File Manager"
  homepage "https://github.com/leo-arch/clifm"
  url "https://ghproxy.com/https://github.com/leo-arch/clifm/archive/refs/tags/v1.14.5.tar.gz"
  sha256 "60aa04cd6e6966107693499028765e13f1de30950d85d3ef29d44bc4d58467b9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_ventura:  "392b93d6a4f8cfefd5c367dc60d10892ba1f87c56024aff162610ab1b5f580f9"
    sha256 arm64_monterey: "7da7eb83f81d84d8bf747f941f7226a45576f56758fa1244a10afd1ee2ad4f8d"
    sha256 arm64_big_sur:  "f284139847075fd6c9fc0d487b86bcbe4fac1829b84af630480eeada1ed22a1a"
    sha256 ventura:        "35c88aa8d17c6f735ffa6b9229a9225038fc4211c9ed8b632f373cee33c004cc"
    sha256 monterey:       "d101f99dd4ced34574f2e8270966ec404d56f1aaeb29ea91740a162ea3685df7"
    sha256 big_sur:        "e1faf10dc6c3c15685528817c9bedf26dd6044825c7726af16034ac6af58d4c4"
    sha256 x86_64_linux:   "f2c3de2dad8dcbed22119444e5c9b24518c599933bd457ac5b7bc5ec87e20fe3"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "gettext"
  depends_on "libmagic"
  depends_on "readline"

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # fix `clifm: dumb: Unsupported terminal.` error
    ENV["TERM"] = "xterm"

    output = shell_output("#{bin}/clifm nonexist 2>&1", 2)
    assert_match "clifm: nonexist: No such file or directory", output
    assert_match version.to_s, shell_output("#{bin}/clifm --version")
  end
end