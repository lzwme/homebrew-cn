class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.125.0.crate"
  sha256 "56601729e4739333c89c4778e07d11265295d8e0e8848e9a210b5c8db8b76dd9"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "49440eedfde829aa20cf09350314f59cff920d9dd16fc3ea832d254270a4c2dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ee17dd0cb2674dbf1131b5aa898a01216d85062a16eb2c521b852981350defd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f54ac74b1603673c78061eb376f9acf318057c75a783b0241782c97a93cda92"
    sha256 cellar: :any_skip_relocation, sonoma:        "5df98feb237dcb332393fca0b200f2e80ffa36e131fdf7702c12ff795bc68e63"
    sha256 cellar: :any,                 arm64_linux:   "99d2bd2a4d9ecb47b22375ea8f91b519b6ba2d99a4d9a488afda101761351818"
    sha256 cellar: :any,                 x86_64_linux:  "e823a0ac0fd6c6c8e00f5449c85e1d72b4432583f19f73eb2cef6c69191ed301"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end