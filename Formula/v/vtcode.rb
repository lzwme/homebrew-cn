class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.158.0.crate"
  sha256 "b93c62d2919a28f4d1f561faf2498b6ef50936091e520c92da5b9c1712efa4c5"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "549820a8dec2bc781106b0186d3bf29df8db0a91b3dcdf3bceff09f943d9a84a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0dbc28e5944fa59afdf56444e7a1a11f6ab19f7fb09101a570e278b666f2507c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a35d952d49fe02b4e2c76aab8465c621bc922e82526505e45378d8db35ff98b"
    sha256 cellar: :any,                 arm64_linux:   "20524622aa18c071952a8bf43e704d27abf9ececf1bbee7cfcd576743fc0db04"
    sha256 cellar: :any,                 x86_64_linux:  "1a2a786ffe688b3f925bfc47eb636226c9f190e0687fe5900d7bf716084cc329"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
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