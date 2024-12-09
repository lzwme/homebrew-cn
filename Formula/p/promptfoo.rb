class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.100.4.tgz"
  sha256 "f8e551913e6861e71fe70cfc3866ccedddabb378cee58fd9658a31d8b5fe6379"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e1b1cc0dc30ba4031b45c7a4cbf8a0014653d9b42c45a6b40c7f1077b88d494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d07769347dd05c48dc075a58833c1783117d297463e02c17b803c23addf1f1f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c756096fa36189e43262bc9a5c8ced1434ebac160e49ff878b205be40a2ee53d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6fb1a0b888efd0cb67d80d1607723b46f9290ba65b33ae5008a5326764ca03c"
    sha256 cellar: :any_skip_relocation, ventura:       "d6946546f039a8aed1af3a54a192abc01d674f3ed7790eea746b2db7f86e5e88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa4b5bb56dae40fe5d40cb6cb338ac06093449189519c87b8b9e1d718b120a56"
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