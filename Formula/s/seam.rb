class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.34.1.tgz"
  sha256 "d1d4e8e414e7bcde26562e58a4386e0e85dbdc864c1a429557d12ab909db94dc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acffd896b3f11ad2b8b6cc3c2a2c17ae33bd6954204bbdc7d21880a7107725c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e755fe324891ef043d57994a1b88b4e31193330fcba79fb2e84ccd70068b9a05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "677ea2003ca38f2f994d3548eac2becc6835f349ea683227b90f0686376175ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "704c23de969b3b39fe88d1065f337e72c48d402c5549b7dc718a51d83952fb31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b19800962cd2f27dda2dd593dbf3cbe84da57f543cc80c10a2029c9ed322d49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5db220d7ce2efef8fc985404339ffe1c2be8dbfd7e7796f4d3dc8458cdef123"
  end

  depends_on "node"

  def install
    # Optional dependencies include `@anthropic-ai` packages
    # which uses proprietary license.
    (libexec/"seam").install buildpath.children
    cd libexec/"seam" do
      system "npm", "install", "--omit=optional", "--omit=dev", *std_npm_args(prefix: false)
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