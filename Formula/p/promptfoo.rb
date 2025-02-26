class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.105.0.tgz"
  sha256 "00e56d62d069f2e3894ad06e88fab383160f7528c068b6c4ae1028aefdb90139"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a62f81a7b9c30a46d86c3fb49b4fc489784c5f86892f4e4c515de7b6b0d803e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9afba7b02b173f568370e565c3392ec3068d8d60a9237010435b2efb82a0146b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "19cf498391d5fee243b757f64770bf755ff6a861cbc9be25382ae3af2136f374"
    sha256 cellar: :any_skip_relocation, sonoma:        "7490f9e44ad0267cf5c61b8ebaf1527ae5e75d262fc204bb2404ab6abd7e75d8"
    sha256 cellar: :any_skip_relocation, ventura:       "e756a88a80b37a81cd283c56caeede591989ca2d02336166c9d6ba073004255b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99fd0cf015eaf152a9fb505668d1678a20d4bba7d9442a79b28fe67ceb99a6c6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_path_exists testpath/"promptfooconfig.yaml"
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end