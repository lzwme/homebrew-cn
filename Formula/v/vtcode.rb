class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.141.10.crate"
  sha256 "499093b47df68adef37dc9536992e5135e39284013b982d91f6646fe19b6dadb"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e7c23db7e603f7f4b3612685900c6f27c2a18a8c2b6a6f2df83855b8221a238"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d141cbda6e5c7cfbb5413a9d31e548e3485aa4022894c249cca5c3fbea31dfa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38cd3eda3d76cf3fbc77a9007a86bdaa526a6983d71c906a8613201c58ceb63e"
    sha256 cellar: :any_skip_relocation, sonoma:        "abb83e9ad814dbe4b1738e5f7e60b4591b0366dcb72400700ca1ef820637d4ca"
    sha256 cellar: :any,                 arm64_linux:   "382d22984a0e7e34cd269d63a5cf00c89032c916b547dc0c877e3a47b289aa4e"
    sha256 cellar: :any,                 x86_64_linux:  "70a7ba92d65605f11167e5e644937a972669aae93c0bd479e12ad4607d32bd70"
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