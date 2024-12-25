class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.103.1.tgz"
  sha256 "bad0c04946efa0a8cc231cb9c3ecb2ba37296a2a88df27f37d27ec0a2ff7ed96"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3f07edec5b2698b5453226ea6d7bfb80754fd2ce4be1dc54e49c044a82cc0f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b378e0e234008c38bba7837661a3f9050b9e4a3a443943ea4949a8ffd9b8d0d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "92ab59b8911d061d73f9535279fe020a5ecbd92f78d46d3c446eafd78441e883"
    sha256 cellar: :any_skip_relocation, sonoma:        "607ffd26931c1648333d2641ad6ebf442e5c115edc792ee97f1e0a7292ff0c50"
    sha256 cellar: :any_skip_relocation, ventura:       "d1116b57ba2668ee54e8c207e688dc5a115a9444959a3cbb008993ab854b07ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6116942e2cc39b41386a0168687ce81c721d571422584eecbe0226e90524efd8"
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