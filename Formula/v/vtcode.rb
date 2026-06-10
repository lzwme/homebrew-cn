class Vtcode < Formula
  desc "CLI Semantic Coding Agent"
  homepage "https://github.com/vinhnx/vtcode"
  url "https://static.crates.io/crates/vtcode/vtcode-0.123.10.crate"
  sha256 "622da97fd8c7ada24d6aae37e3ce67e0daa739accc13065fde639b1fa5224ff3"
  license "MIT"
  head "https://github.com/vinhnx/vtcode.git", branch: "main"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb857a4247e02025e8cfcda9a4c39ea59ecd5ac0a9494f0c563f858e1fc5d24c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88c7cd654c7fd2c44bcc712fc82cc17f533eb7e783b38cb4a0a74a0935f805b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cfc0583eb4c03ea408af7e60a22cb875154ae049033fd0acbded3788bc413ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cc6741cc4b828548b1a6410fbe1b09bfb7701570d4c6a77b23edeee4cf6b94f"
    sha256 cellar: :any,                 arm64_linux:   "73a6e685b93141933f08340a9876f227510d9cf71af65ddd6803aee214cb2ca4"
    sha256 cellar: :any,                 x86_64_linux:  "8f7465f77e47f204b5dec4f0edfcfc8a5bdf96d75188026c258dfb3525f9c829"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ripgrep"

  on_linux do
    depends_on "openssl@4" => :build
  end

  def install
    ENV["OPENSSL_DIR"] = Formula["openssl@4"].opt_prefix if OS.linux?
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vtcode --version")

    ENV["OPENAI_API_KEY"] = "test"
    output = shell_output("#{bin}/vtcode models list --provider openai")
    assert_match "OPENAI", output
  end
end