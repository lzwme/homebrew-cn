class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.149.0.crate"
  sha256 "93557636caa1723348f7319a1611a6f7f9ef64d231429e569e7d2517ce047f46"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9b81db6eaa13a2c54d4926be81b318e477321cdf985376a9456ff277e59fadec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "951537d41703b5db94af609c4a9b8e0e350be382e9ca155449e34d5a356ceecd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d97eefd05e54a4bb142d58fcd55ef5d6e70616a6ac734da8e3711a5b2eb62aae"
    sha256 cellar: :any,                 arm64_linux:   "1481c958185069a65a6d667b3100604327fb0f009885e38178adad76ef4459cf"
    sha256 cellar: :any,                 x86_64_linux:  "51526911abfedb264f475177c38be2e2c12cb5261a0020456d37de7855f315bc"
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