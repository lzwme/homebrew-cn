require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.73.6.tgz"
  sha256 "2d4862044fc9de75d7feaf2a2a9eadb389c3d6ac39206ac1b74dc55ff5b01fe0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c8b7959fda34dd97a73cdc8a7ac6b8eddd5e9649f8fefda39ff9836b0709d6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "61717fe4cd37239ee4aec4e2a313a024d0715e06f5eb2ffb43ca38441d4a5161"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ac015f1a94122c4448a235735fa662d95c103e4f1cd6884cb73227efab1cc40"
    sha256 cellar: :any_skip_relocation, sonoma:         "654f69de21fa57383b7772ccd0a7d71b3a1257717e3640a825ddaf6db9d0cfcd"
    sha256 cellar: :any_skip_relocation, ventura:        "3f563b953f631bf23abfa034690c5ca9c1c4fb868899bf67a8fcf328027770df"
    sha256 cellar: :any_skip_relocation, monterey:       "df9c260aec86a8e919c954591cf11d1475ad08c7b9835de522bed394102a2b6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dd79087405f113afda0a43223d7c6259cb2c371cdab0eb38868cca1c687f54a"
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