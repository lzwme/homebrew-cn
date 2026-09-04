class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.154.0.crate"
  sha256 "7b41d30e1a82a57181ddb8a268cf9c0e7d48d8bed629f7b4396c35f109f98d27"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9aa7fda88a2a20a4ceb2d10a69c222e797c5b0aff304fb7e603c6df30fbd8d84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fbcfd9fb006df627680304c3c8cf2e146cb3e74995f4a9fec442c470eb41e9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdb5a1a43eec90336c2fb270a46f2144f502ff5617cbe7db2caafc3d72debb84"
    sha256 cellar: :any,                 arm64_linux:   "8ccefb6f38d3653dfc41fd54d023793d92480f991f5da317327c0522b7738526"
    sha256 cellar: :any,                 x86_64_linux:  "d258e69b58cfdf43acb4d365d30a77d86decc5eee91ff265ac79fe66b7f26564"
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