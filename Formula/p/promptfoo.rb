class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.107.7.tgz"
  sha256 "eabaae39415f19410c11aa52eecc90b08b80f2cf1b88ac33273a94eb3b7542c3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "18263baf1e3272556f98abd3b0b4f106c3826bc4a17d39791bbb2f3475970a44"
    sha256 cellar: :any,                 arm64_sonoma:  "a7328eaad855215710e3557b14afa7baeb37b74ddd1f5f283c76812281f112d7"
    sha256 cellar: :any,                 arm64_ventura: "5ba4817a86cd5db1f936ae4a7ed73551c849755e385cad1705be639ffd909f57"
    sha256                               sonoma:        "a89df537f69c7193b85070c6b6bfdd903afce6239de4ed2385c2d7c18894fcbc"
    sha256                               ventura:       "54419b453b0800508e680fe3565658712d135475361390b20c089b01c6095667"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cca230da90cd1bdc00d09aab829c00e75aa425898576129598ef7abd39bc3467"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8dd9fa1be97a1ce9ee85dc3de29f17f548ee184c88738de3736432105841cb5"
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