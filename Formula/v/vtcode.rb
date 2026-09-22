class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.165.0.crate"
  sha256 "93a4358902feb3896be29494fe3dc9de8c10f1e343a4d70152fdac2014cdff91"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb6a08fa25e761fae438cc50c1a3113340f90cd858593ee7e7844ef0e06924fe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bd19117afd5ed745b02d86ca483e1524eb7bccf62de4a76c9cbef640535fd590"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8f6a975752043596522e5e20340c6d22ce28b0c24d96e6e4b9d4f3538a044b30"
    sha256 cellar: :any,                 arm64_linux:       "6e9a5fc9eb3dc8a82c48a9fcebb412513a3e31c1dc550ed46443df2930cc0b39"
    sha256 cellar: :any,                 x86_64_linux:      "b700e760bc8d5439617d7ebec6f9e6ed54ddfb3a04a51fdfb5662f707f8e64f7"
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