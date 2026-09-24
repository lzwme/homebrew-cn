class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.169.0.crate"
  sha256 "e5ab6c165bd5407e3618953aa661dda9b48d7a0f7a0cbf45748f5675a3141443"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e634ee16c2c7d8a679065368e3f1113d43c15b4b55baab284ce19f3dbbb5b825"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ad109a385a4f07fe6cd92dde8da4e74b43a37dcfb35dc0f188f4e7cce06e79b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0929f188f343f136719734239322906035396f06819c763df7fee3ce477295d4"
    sha256 cellar: :any,                 arm64_linux:       "514265531224383fea631d30781ffdc0b87c4ec074397f713216da4ae5a12c07"
    sha256 cellar: :any,                 x86_64_linux:      "9c61d2588b8d37a113bec6598b9498205b89326bc4b9b035c648d187aa86757d"
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