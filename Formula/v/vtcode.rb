class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.179.5.crate"
  sha256 "17549b62cce730f1236140d472ff803ee0b65cf0e68124ba26e85cbff71863c2"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3ed3962aca31cfe8896653e37bf969a1a5b74497fa98d533a6a278f8b9f7710d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "855938511479b71328b3cee9802759c9fbaa8b3985613a26083fd6117dad089b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb8d254e0d870c474a2cddb5fa0c7ebc7c6ed53785b453198e55b22749cb3f70"
    sha256 cellar: :any,                 arm64_linux:       "c7c83c9452756c54c860b0a8421474eee09d2bae6a8dfe1bec4348a555a1929a"
    sha256 cellar: :any,                 x86_64_linux:      "74180bf1d9ffab874104f13734c44e41373cbf6530b985a250d9f27533ce758c"
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