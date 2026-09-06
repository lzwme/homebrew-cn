class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.40.0.tgz"
  sha256 "de11c3a41ba0f69695d5d26f37c57d43a9d1028fbec5b3ef3f0ef0c31f126c1f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bacf2246052ecd5da2116d8b02dda7bc3cd74b5001481143303738207cefbac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f25196a6809da144d81c7bcc7206f251a1ef42ac110b6d45756c66d55ebcad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c65605e36ea5bdcb234f37167c9295a52095c63d7c9cc558c8ea224bf3c91fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c37d4cba222de736fcc15ef62159a436917f51398ee64105355d806a2c03b1b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "273de5dc532f9c815c056050e3567c0a1e2c3c9e4ac3fb06fa9802c235e7c1e2"
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