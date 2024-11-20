class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.97.0.tgz"
  sha256 "8cd0c71b27aeec33644495ebe50cc6ee0efac9ab5c83ecce5b9bed8ab4c9fd55"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "907a881ede458d454f7c9dcfe2bb86bacc1098a9eb90b22370e02c642c6213ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "095181920d7e481195f68caab8598edd37d2438ae3bdb38a649f29d9f4297758"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "81331e421c5f81f36a67d2669da55a04d1262da62bdf38e06d9d67049b0f7961"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f09e4c4d5fef5587cb6a69e577971af2ef4bfea43e307d5ffd1ae9654ccb8fd"
    sha256 cellar: :any_skip_relocation, ventura:       "d4027337121a3743bb21b95e9aec314b50f8f14c6a027f40d576d64728e901ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d54ed991524967d433be6929237f92937fc346374acd32974ab10fcaf934ca5e"
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