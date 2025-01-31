class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.17.tgz"
  sha256 "1f10758ea3164fd1aa1c36ce4aa894238473f7623cdae1036f54baf1d31e861b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06a002f3d00d99d52f83390a1c788069d3383db8f705cc6d84a3c2494a74d474"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c1ec681179bf96b96d5f9e3eff29ddaf7a1b6e93322d69ecf9fa1687c5e95ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "72d00bd67afe6b20aeba5252d26fb84f24125f98601afa04953ba72dee5d8c67"
    sha256 cellar: :any_skip_relocation, sonoma:        "82858c181d6a22d3d0db9cd54ae143789e76dc66102c544823b21b29506ae18a"
    sha256 cellar: :any_skip_relocation, ventura:       "bef59c8ca30dcd2191caea3a91a04495d2ef0304e9ec592a50b353599924e73f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aeab713a27ac159f7de898edc4e000c364078a723ff37a9a88d78ed6d97e30e"
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