class Nmail < Formula
  desc "Terminal-based email client for Linux and macOS"
  homepage "https://github.com/d99kris/nmail"
  url "https://ghfast.top/https://github.com/d99kris/nmail/archive/refs/tags/v5.16.4.tar.gz"
  sha256 "5e563291964d60d4c73aef6e1d7067958960be4a9e99c1c3735dde82c5166dbe"
  license "MIT"
  head "https://github.com/d99kris/nmail.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1f0472adc9c25a53e40d071ee93295adf21701290a8f7ae1d742a13bcb01d544"
    sha256 cellar: :any, arm64_tahoe:       "c1d29d5ba630473e179744cd7fded0264a2a54e3ab3222f10be470cecefc5ebd"
    sha256 cellar: :any, arm64_sequoia:     "67035bba568b6bcf6ceb140f537582b1b794f2775d1f15a67622709468b787dd"
    sha256 cellar: :any, arm64_linux:       "77bd992de07b6d154337ee7338e75b95566666af141a6034ecf7ddd149c47ede"
    sha256 cellar: :any, x86_64_linux:      "9e53a62dff2e1f017609ec14b4a295b13d53557f5a6cb934a7e9496141842ec2"
  end

  depends_on "cmake" => :build
  depends_on "libmagic"
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "xapian"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" # for libuuid
    depends_on "zlib-ng-compat"
  end

  def install
    args = []
    # Workaround to use uuid from Xcode CLT
    args << "-DLIBUUID_LIBRARIES=System" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/".nmail/main.conf").write "user = test"
    output = shell_output("#{bin}/nmail --confdir #{testpath}/.nmail 2>&1", 1)
    assert_match "error: imaphost not specified in config file", output

    assert_match version.to_s, shell_output("#{bin}/nmail --version")
  end
end