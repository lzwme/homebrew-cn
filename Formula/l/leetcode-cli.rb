class LeetcodeCli < Formula
  desc "May the code be with you"
  homepage "https://github.com/clearloop/leetcode-cli"
  url "https://ghfast.top/https://github.com/clearloop/leetcode-cli/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "52bc5bac21dc52a0d498c8b817f9e04c7267ba9febb08d4ed0a158e91893d6cf"
  license "MIT"
  head "https://github.com/clearloop/leetcode-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89eba514f6e4e74196b14da22f66bd1606e4443526f0a5b040162a39e9096ae0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81de105f24d4f931fda817b5f92a7ef63f1838585353b377ed2833e1a027bc04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "643e1d92c4dbe15fa0785c2fed7ed4a0902ac8a09a0c63d1e27a922f6b776f35"
    sha256 cellar: :any_skip_relocation, sonoma:        "5771a1ac94d3d0533ce4b96268f5a87ec6f08e92c9f14869e2ab95ffcf426c94"
    sha256 cellar: :any,                 arm64_linux:   "98f1ec4e2b74af6a76b49b8a337aca44b39baf2fcd9e026689f973b77598a266"
    sha256 cellar: :any,                 x86_64_linux:  "63a3af92d40d1e433b815761058a4b3f531ad091e63e454703bf729243565ea2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"leetcode", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/leetcode --version")
    assert_match "[INFO  leetcode_cli::config] Generate root dir", shell_output("#{bin}/leetcode list 2>&1")
  end
end