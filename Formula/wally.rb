class Wally < Formula
  desc "Modern package manager for Roblox projects inspired by Cargo"
  homepage "https://github.com/UpliftGames/wally"
  url "https://ghproxy.com/https://github.com/UpliftGames/wally/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "c9b8bcdbfc906848fac5a49d69f54d3b2b4830b23dda7cd47190c5624c2bf04c"
  license "MPL-2.0"
  head "https://github.com/UpliftGames/wally.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8bcd3a2941b670b540cffc7977b6af9424de869bc0b2df5e4863f5f72289b418"
    sha256 cellar: :any,                 arm64_monterey: "3c7d4523d9d56861fcf5f364ecf138a24b7490dd0a3dcb072b601a6024bc9944"
    sha256 cellar: :any,                 arm64_big_sur:  "e4ed5fc15d3b87e647045a32b12e644295add9acfd4c92d24daed1634a4261c9"
    sha256 cellar: :any,                 ventura:        "45be1120a59fb45a27e8fa24a3b9f98b8728a24cba8daf2503a2536e737db0f8"
    sha256 cellar: :any,                 monterey:       "a24775ead88d54d16052c184a7a2b18b3883e8672d6b44a74b5774a65d73c530"
    sha256 cellar: :any,                 big_sur:        "fc92c9692239c634f08a9b25df8a1c4e4c486e2b0b1f4f312c4ec3268a77a70d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85e8d9950094e3f98273f8de2fcdafb71967630697bd86d37ea3f98728b1bde0"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  # TODO: move to openssl@3 on `version` bump
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    odie "Check for new OpenSSL version" if version > "0.3.1"
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
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