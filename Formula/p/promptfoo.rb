class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.92.2.tgz"
  sha256 "e9da00c4c21377191dea80645226387a8470ee4b092cb31d25c8d07f1109fb17"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "415bca172ea0534d6163c3c83e547b49777f7d414780b54bd7a049c338131f16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f8d3384db6647115bbffaf687ed396c4bae7a9224b0d127117bcdd98d6a0a99"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7a0f70dd1b5684125b6137161c4b7f118693daaa2f5b1fa72f2ed784881ae888"
    sha256 cellar: :any_skip_relocation, sonoma:        "c359efff8c1b134c367fe2d94f1e3c6cc82b0dd5ca9e04a2f0876e09df9a96e7"
    sha256 cellar: :any_skip_relocation, ventura:       "131c0b05f9ea6fcf78eb8efd5d28f65c66d5853adc4eb9e9bc0a077160360630"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d1823cdb93e98c8e800ffc14a1b2dadec2b206820731709a0d9ca6d083bb07c"
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