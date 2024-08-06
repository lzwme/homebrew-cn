class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.75.1.tgz"
  sha256 "5465711d170400d2f9d3c334d07cf9f5a33c8d28de5e2530de85c1206079d760"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "096d422a4a86387546cc7415de0866768cbd30431fb0ce7721bd0420678ffe9a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07e93cd946dc9ceaa587113a4e72c56c8c1f8235e008bf657cfd234c51c8bb9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08b734c19571cd922853fe9ce22d6544c9b130453a2c5e81386993e808481883"
    sha256 cellar: :any_skip_relocation, sonoma:         "8c8595d8e03818f66d3ecc4d04fab0cc6539f9f95ba8fe0e2c9167e816b031ca"
    sha256 cellar: :any_skip_relocation, ventura:        "7a8e05bca98d8757ce92c8bcdc875ef9e5509eb69623ce50d0028cd4c870115d"
    sha256 cellar: :any_skip_relocation, monterey:       "bcd7221022f965d02e04d3c5de9dd08b7c4a3fe6dfec0d457a2d9fd5d8bade13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a359a53afac5ea98dbe4d21aafa0300f84b281432ee844360b111a9a92a9aa3f"
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