class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.119.1.tgz"
  sha256 "98f704ac89357f942683226c7b02dae1ece35ce79f0fc0fc705263fb45c0352d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "75b2ae623b096ebf5f2166d563010763e3d8d238c4e4a12189e90c0400a0162e"
    sha256 cellar: :any,                 arm64_sequoia: "4249b813607bc90a540eedeb74540a26445234b53abfe74b8a74e14bf2058381"
    sha256 cellar: :any,                 arm64_sonoma:  "404cfed9da499ce0424972c1309974d9132761ba987e328e5f0eeff942da886f"
    sha256 cellar: :any,                 sonoma:        "deecbc4036dac7cced69c2b46eb1dc683689955ed87d99e1737366142fc3b0cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18f6401fd7a5b5ad5ce4b0a73fa87ac98c17527181781e172d277a9387c02247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90541936fec61fe73e05372bbf3f9b73c65583e68516710fd49a88653a9b0172"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/promptfoo/node_modules"
    ripgrep_vendor_dir = node_modules/"@anthropic-ai/claude-agent-sdk/vendor/ripgrep"
    rm_r(ripgrep_vendor_dir)
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end