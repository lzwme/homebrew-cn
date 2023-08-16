class Wally < Formula
  desc "Modern package manager for Roblox projects inspired by Cargo"
  homepage "https://github.com/UpliftGames/wally"
  url "https://ghproxy.com/https://github.com/UpliftGames/wally/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "f7da2a10865b05efe97273aa1d08e0efbb9d26fecb770d819bdc01fbb98a0ad9"
  license "MPL-2.0"
  head "https://github.com/UpliftGames/wally.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c2342665f1ff90ae3b398b6f77f6a8b13a40cb28da096fd90396d311f49a6954"
    sha256 cellar: :any,                 arm64_monterey: "c89a4d262ef25cabd1314c9199386ad26293245329bc4b4f42ca61efe0e671ae"
    sha256 cellar: :any,                 arm64_big_sur:  "e163760b40bb391a16d79959b2900441b819a128b20fac990728d757daead46b"
    sha256 cellar: :any,                 ventura:        "e2b3d38a5a171f0942cf2931a434aabe6a6ca9014c39468918f4711a48b3ccb3"
    sha256 cellar: :any,                 monterey:       "aed7b3c520028f006b526682892ed3a94af7986f68fbd4b1adda297ffcb44bff"
    sha256 cellar: :any,                 big_sur:        "c552601bb3c6eb5495b40e5ac0312243731c47ec2478eb1adb8b0b57c595b228"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66ffa7e6874e0908b42a519d4b67223b668c08e11d3dc5eef078c7e35671593c"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"wally.toml").write <<~EOS
      [package]
      name = "test/test"
      version = "0.1.0"
      license = "MIT"
      realm = "server"
      registry = "https://github.com/UpliftGames/wally-index"
      [dependencies]
    EOS

    system bin/"wally", "install"
    assert_predicate testpath/"wally.lock", :exist?
  end
end