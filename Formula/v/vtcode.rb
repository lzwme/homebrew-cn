class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.171.0.crate"
  sha256 "4c67fb14e371438e4d74d25e25d7396d4c0ac1e84d04bb4fe6d8a311961448f7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "32cb2a891ce8edd0cd8176a9327e516853cb96034c1ba47732b04b5038dc5193"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4a621f83ae4e2d63e9e14aa200f02a5da3e207fbf105ea8569aa782705211420"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "adb7236bee12c0526a46d3bff9bab7e2fbf07e174c778da16a12cb83710d35c2"
    sha256 cellar: :any,                 arm64_linux:       "4bc505a62eaba31aa61df8eebb2ca99f67a6e10d3a94ca2d1a7f441e711cc936"
    sha256 cellar: :any,                 x86_64_linux:      "f20d9a67ed25520098563c4485ec3f32949a3087b8625d1a462673af8a8a2f71"
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