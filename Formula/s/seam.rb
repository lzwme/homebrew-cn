class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.41.0.tgz"
  sha256 "fc4b1341c80e662b82d1d0eccfd604fbb0fbb9cdd88652ab4f7a1fc159f18fa8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "01eb5f9b6b038e11ac59e41a2bddf910929d999afd7a3d481daca5554d56d58c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "082c9c6e546a97b92c8942c6443acfda556eb7c0eba1e183e10a41e2ef8beb5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bb30420c58449b4be73f157940d680a8e44c003c4a311620ce1b70f3897e5c88"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ac46b188670eb91b264d97731cb0f020190fee83248b216c9c0b7e901277e282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "91a42a39a9db0151cb99fc7b76ea9f24bbfc291c0d48718a27abe4a674a46103"
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