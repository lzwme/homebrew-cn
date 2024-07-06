require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.69.0.tgz"
  sha256 "bb776e4212edb024160ef10c87691376ffb1b46a0df667d44b29df6764fde65b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da28040e878b8f5d1d7cabceacdc9b9db0dab8620dad2a24a69c545de57c8f74"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0ca32e9c649beb1b9b8e1d8d1281f1b8a374831956cc09f86ad9934e89cc6744"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95d3b62fc60698e33d4ebd6023aeace8c0d939a6a9a8c5f32af217f82ccfec1e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f44cbaf8198eeb536f7acd9613d1530e74f9eac41eabeb062645d1440aa9a2d2"
    sha256 cellar: :any_skip_relocation, ventura:        "f4ecdd21202258fff1a0b040ade16c25927fcc400772654bf07455e333d9a5bb"
    sha256 cellar: :any_skip_relocation, monterey:       "eea0fc503f4418e0b9a5e9dd043882f3c172673c2a18120c74b04505186f85f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87fb5507e43306f9f78c2cf9d546783524770d97063f590b6464318ee394e797"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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