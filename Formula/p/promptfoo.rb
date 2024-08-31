class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.81.5.tgz"
  sha256 "b48f201424619bd140bac0bb5cf16ce3e249e8b06bfcdbae32d6b44e9f170333"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ec039142562159a3e8fec91375a40f265e693ba00bac3358d4e5cb9b8d9484f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "732a5b66cbfd46444aecd15667dc0c96cdc04d4167e2f52de398235303d9fe07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "713e5c82423fa9f6103aa660f5453f53966d6b984660251c31ec48e7b09ae299"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b10d3f50afd60be10c5328a828ae5b379ab8a6e25d8df9a91b23cf3a88c9b3b"
    sha256 cellar: :any_skip_relocation, ventura:        "d036889007d21c3ef6ed950199d3d5883a3b4c16098ffaeb34ea6238f54abf7e"
    sha256 cellar: :any_skip_relocation, monterey:       "d9d1bfdc8022eda6a34ad9412a494dcb9e6fa922ded7e04bc9243e55b82d4bd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a66d86f94606b3c7c5b37c68f36a0d2f55d4fd1f16e63ef9b53c7b74ec8ed87"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end