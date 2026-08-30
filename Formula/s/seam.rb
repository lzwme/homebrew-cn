class Seam < Formula
  desc "Command-line interface (CLI) for interacting and developing with the Seam API"
  homepage "https://github.com/seamapi/cli"
  url "https://registry.npmjs.org/@seamapi/cli/-/cli-0.37.0.tgz"
  sha256 "b927585809c97e3d6e04c5cdf88a13ab0c4c3ea907ff63cfebe8c813e81a4132"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5840da91792ad47a897ba44cc283cca5a886f8644b73d07379b5d5393553c87"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90ea9b6cd6b9f07a00cee82b2f6ed13538e59f3ee8874d4c712058a3bbddb07c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7f0507e7a9d7aba5fe3919a3f65fbd397fe42bffa07eb9b17e73f6051239686"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fb5042cde8388faa6eb2c1fe8bfa98cbbd41ed1fa4b45a066ed3800f4d7f4bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37c0594bf8fe0a59a36b4e5ee110170917c15a0a45e89269ad43b4384dbda12e"
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