class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.177.0.crate"
  sha256 "f83257d53c6cd6947f220d33b54bbb13f3f353f07d5f9585d331f02cfd0b9b1c"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6603bb75543e517ed074a51d4b77b20c432ded707af51f8e124148a5e110e209"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5c89f399c0a959328b00619712c49c0896d0a5912c122079a2870b14f182c96f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2706e05202c69b745e991671f66830e50dd9e2822802265a0cec8c1504d83dd1"
    sha256 cellar: :any,                 arm64_linux:       "7ee2a2d32ce3110f23e6c90988728dfbb888c02b9557949acba0a67c4db8959d"
    sha256 cellar: :any,                 x86_64_linux:      "7a8200e76fdf736b84340f3fb149b1dc17983db86e4ac9876e38388a88dd313e"
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