class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.43.0.tgz"
  sha256 "f33cebaf15299429a76f3aed651e10aa316db67660bee51650a3b7d9c482b759"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "88eebac30880863584657692b58b497ffd3a8ae087a1012c1741bd6b771b6085"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e350fad251b6b1e3dc7599afd6b631ea552b60b235a6ffe93d22e6ce965d328f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c90905092c5c7ecdaea2ceb34ac4f6cfc1d8a76b2fa881d7f44b4d4db0938554"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "17ecce73d4b370a3a7fa6bf8c4f6d54aea9b142116ccf6dd0d700449f32633e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b539b15595289360a25c91e3e6487609d5d2d769a2a4edf66f53a3fb8e5ba94f"
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