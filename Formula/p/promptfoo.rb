class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.94.0.tgz"
  sha256 "eb07a406ca2a6465041ad3efe235b8c635323cf78685d028f449ef1302d93b99"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa7474169b3d550f0ca9881abb325ae5689dbce726b9c5a4204d89ff72977172"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8504b07de98a57b9ced090862dca30af57b99b70adc0f39409cb57d58ac10572"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3eab45c6309f78161b418ac8422bc21feb40bd722df01a91b10ca865ece1de86"
    sha256 cellar: :any_skip_relocation, sonoma:        "718ace2fd9cefe049eccccbedd79404a00e537ea04fb085832289c216d98d54a"
    sha256 cellar: :any_skip_relocation, ventura:       "ae4ed076eb81be78f575dd0b566942103090d5b863f3a3c0bcaedd95da33b371"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a609ea1fa651bd2445da51f74db7398a923e4979ec07900226bdb930e494bcbf"
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