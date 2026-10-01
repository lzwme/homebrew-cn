class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.170.0.crate"
  sha256 "1ac8deb5a8520cf9178bb4947dce2e02a2d033da8623eb4acb22291a6f30b894"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7b6990db7ef3b4c40963d2726a90555a89967076223776f7df1b9c9681e1d1bd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8ec13fd1680678502f98a19ccac357d7577beb34e8bbba0f251a399db86e3612"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c902e4abbef7f87278ac62edfdec052e3843b3ef303fd27b5488697cdd68d3b6"
    sha256 cellar: :any,                 arm64_linux:       "f25537a321e557c7131789f5e15d02022a6a9c8895e807c646963737ba76d1f0"
    sha256 cellar: :any,                 x86_64_linux:      "37b458f8d0b52dea2c5d8c192adce875c3e8a22e5900ae59d54ba4f75369b17b"
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