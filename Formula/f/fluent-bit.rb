class FluentBit < Formula
  desc "Fast and Lightweight Logs and Metrics processor"
  homepage "https:github.comfluentfluent-bit"
  url "https:github.comfluentfluent-bitarchiverefstagsv3.2.10.tar.gz"
  sha256 "f86ecbe208ae152841909a063f28ca250b8a6771c5e43dcb1786ef310f927904"
  license "Apache-2.0"
  head "https:github.comfluentfluent-bit.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f1b445adb9da5b1d3b3e633cb46d146d5c1078a48589aaf12c2cd52d64a71a62"
    sha256 cellar: :any,                 arm64_sonoma:  "5ae1ada15685b68b6525d03d214e12ad8b6200244b19817deb70b29e67aae427"
    sha256 cellar: :any,                 arm64_ventura: "28e80667b41697b893cf8e7fc86aae452bcb9370b4b3156cf4a37158a6c8082c"
    sha256 cellar: :any,                 sonoma:        "0b9dea38caa1106e90c8f904735b3a4a1727f1d1c90797a09f44c895408d51b3"
    sha256 cellar: :any,                 ventura:       "f8d0141382569e167d36587317345daacec1a772509c8b54034d9c07021f29ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1f95851c761e746bfced58e866292078f0d566bb4176327d7f513dc11d81939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca393feaeeb23098806be9a850e0af496b85451f2a5b5fa23294103e14d82d3c"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "pkgconf" => :build

  depends_on "libyaml"
  depends_on "luajit"
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    # Prevent fluent-bit to install files into global init system
    # For more information see https:github.comfluentfluent-bitissues3393
    inreplace "srcCMakeLists.txt", "if(NOT SYSTEMD_UNITDIR AND IS_DIRECTORY libsystemdsystem)", "if(False)"
    inreplace "srcCMakeLists.txt", "elseif(IS_DIRECTORY usrshareupstart)", "elif(False)"

    args = %w[
      -DFLB_PREFER_SYSTEM_LIB_LUAJIT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}fluent-bit -V").chomp
    assert_match "Fluent Bit v#{version}", output
  end
end