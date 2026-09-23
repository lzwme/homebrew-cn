class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.168.0.crate"
  sha256 "0d50d942dcf98d9386fd127bea29c052783bd56ee1b96fdc12844351054eccd3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "87b07bab4a5a25edbcce43184c1da3de857627a3706bce9811960d1fe1aa42b7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ee95f5a8237656650b18c141aef3a7765becb2797b2a3ba542282bc6e0b7c158"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f8d615c921b1a0e263250b5aa79466c815a0077acfc32f15d034bb8e3be6e7c3"
    sha256 cellar: :any,                 arm64_linux:       "52c0c228c7c233454ec97299599391183063d0b7150c87a71779cd43e7b3ab19"
    sha256 cellar: :any,                 x86_64_linux:      "5efa07ea559044045a0f75adbc3d560d5e16d97e8118fe1ae49aa0ee3b810b98"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end