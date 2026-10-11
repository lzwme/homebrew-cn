class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.46.0.tgz"
  sha256 "f57327ee4c49cecec407e2cf9b938f8392fb664aff4f17e75c71d08ffd2fdd6b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bf0f210cef2bf921247acd182a836dcd8b40640adbc004eeeb0b89a328965610"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b8987d19881a7970411850a8677605274449f9f165d3c29e32130aade28b34eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a663c67b59d2620b38cfaf10da8fd2c024f213d63307e9ac3b087d3d916a022"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5ddd48f46949dc5fbd9011c1a6336beb4932d11ab8b9e8615c4cab1e41bf76a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "861b2221c13369b24de5221230dc651da4ecf88355b1b140906949eb252017ba"
  end

  depends_on "node"

  def install
    # Optional dependencies include `@anthropic-ai` packages
    # which uses proprietary license.
    (libexec/"seam").install buildpath.children
    cd libexec/"seam" do
      system "npm", "install", "--omit=optional", "--omit=dev", "--legacy-peer-deps", *std_npm_args(prefix: false)
      with_env(npm_config_prefix: libexec) do
        system "npm", "link"
      end
    end

    bin.install_symlink libexec.glob("bin/*")

    generate_completions_from_executable bin/"seam",
                                         "completion",
                                         "--loader",
                                         base_name: "seam"
  end

  test do
    output = shell_output("#{bin}/seam workspaces list 2>&1", 1)
    assert_includes output, "seam login"
    assert_match version.to_s, shell_output("#{bin}/seam --version")
    refute_path_exists libexec/"seam/node_modules/@anthropic-ai"
  end
end