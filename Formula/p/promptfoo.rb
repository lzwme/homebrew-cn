class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.117.4.tgz"
  sha256 "03afcb17868240ec6fc86f2b2fd7b26e7efbb27958b2af30ae77e182ba4a1842"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f6bfddc029852b5e2eb00165cb77e2e7174a27e1d9709a6bf9219567d088a1c8"
    sha256 cellar: :any,                 arm64_sonoma:  "110fbae49b2de47b7817161c4188d45fdc125aabba66cf3e89ce6aa5c1782695"
    sha256 cellar: :any,                 arm64_ventura: "455f60dd1c224abc221de2e4ee86918c3e6946ebc76d5a82798c5ca7575809e4"
    sha256                               sonoma:        "24cbf05d8328bda12775d40b57adf2f500e3f1d51f03b5b7e807b5836a5685d2"
    sha256                               ventura:       "273b23087e1291983b0483d1eb15aa36ee2aa7f93cd2b156198bccd4f83245c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b97b09cd2100861ce54e572fff54a6898d52b4523db8f83a5719f1ffe92a237d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d2bcec3ba3f87ebaa17a28c0a51081d474f277c9ec47ae0341d0172274c912f"
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