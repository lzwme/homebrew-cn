class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.38.0.tgz"
  sha256 "7f49335dc643c5f40c345b8503e0e6fccaff452025a70c737227b40c43e187f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01e4d7f4a2d87ccab48b50e929d68149bb9d17604c785110f05dcd49d932bdb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "931515e8c01e65aad02cbfd2f6ef9cacd86a4ab414a424c59fd03059b2e98a21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2af0904bd5684b071452f7d48c9ab7631e4c67d1b5b36410e15b8cdddd79be19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "11532007a568fad7ce321c592f11aa9cb955f147faed81be121e17e3d1ac4cbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5096bb17c7f83c6c897c8cfbc010d1f2ce90e1327bca2ca60ce7fac77e2e3de7"
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