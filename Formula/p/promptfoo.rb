class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.104.0.tgz"
  sha256 "e53deafa9aa77a597021b6835c5cf9a79443903f97df98b0c6406ecdc96462c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e35b45b52771d87d30511a8c6ed0f739c75daec48137f36fab7bae180bda606c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b302428e2f8b877773844129244fe9ef55cbf9d27170be3a3b300c7dfc16ec6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af3b7df23e0a1d846f844b7017e5a792a9aa688d4cbe3c1395dd8ce98f6e274d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0f25fcfa442f1089d2471a08a7c7e59cd29e3c072502e03850b2e62a145ba0d"
    sha256 cellar: :any_skip_relocation, ventura:       "af24eaf235f40c53f73079012d3b7407e1854e6c20be23c2fdd1093936f1206c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36d6143e3f0c63c6535cda59bd3ea382af48de6a84aa1de53f3d83d36180ee42"
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