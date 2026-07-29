class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.141.0.crate"
  sha256 "4339322fc12dbeecac2e9830cff74086b7a4a3d5202f316b0e4d046a5dc975b9"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a5210de29f3308b3ea6791aaa89dbd7ed77738c3a14b40f275eab50d0ea6f97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae3541f1e0bfcad36ee1b5b4b8a23c642b831a3184cd58c479369b1742666d95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd1457c595b63581c54cdc2bea284c9822f2f6ff3229d8644eb4fc3b98c0c5c2"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2a1b1779f42a8143a9a78b16220ec4b0487cb45861b56da9f3afdcaafa5c2a3"
    sha256 cellar: :any,                 arm64_linux:   "6667c635863dfd5f93c924b0352305652698d726562e6f54d130b07ffb29004f"
    sha256 cellar: :any,                 x86_64_linux:  "cf3de3339f7f11141c270e2fe651bcca3ee8612ff295725a7357ece16be07efa"
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