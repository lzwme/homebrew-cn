class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.141.5.crate"
  sha256 "6b49345fadfa462dbf954df20d6c6037aa8ab4b7f31a91a4e8cd10c0bee8b0af"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb983b5eac0c9f98903f0c0176790d72faae41b4a07a6c5c36573418a65daa3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3c8504df3288c2b0ed60427f653bae64cc48a55b75323a69375225c9899399d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e403d12fc2bf3922ea9afd241650d684673e3b6dea86efa93cb70ee601626ba9"
    sha256 cellar: :any_skip_relocation, sonoma:        "31c26c99fd44a6105987b2a328f71a083e6efc7ef1dc473f3999a8c74a311d4f"
    sha256 cellar: :any,                 arm64_linux:   "6c3aaec1013fdb24d36f788829e66196105401394a89ba778d9923b0b5bedbf3"
    sha256 cellar: :any,                 x86_64_linux:  "ecc8fd706d6812c7b905435d4126875462de15d8f7139f31713789ef0e4d3fc5"
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