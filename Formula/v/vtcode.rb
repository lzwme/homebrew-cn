class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://vinhnx.github.io"
  url "https://static.crates.io/crates/vtcode/vtcode-0.153.0.crate"
  sha256 "e0f61112f888b648f4f08b7f8ee22d36f607501419b4758f81c725bb8f909ca7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5dcadfd6a1bf4ca6fddb15061a024d88918683e913bf7951fa1735e06da2260"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1122ef165487240400ec409f40141ec9ff7ee28d7d4dd27acbd2cdab14db0e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f412f69450d43fda37ccd42d2cbe07d69bdda3c7731a784cb52c8d42f7bd9997"
    sha256 cellar: :any,                 arm64_linux:   "ff521fc09f8ce7a70b90240766f6d1df90d25d62faff89e736d5a770ff84fa0e"
    sha256 cellar: :any,                 x86_64_linux:  "7a0c94eee13406727c7787965f94a4719e64acd967dbd8b37cb755575f5b0bd3"
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