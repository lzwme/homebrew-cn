class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.94.3.tgz"
  sha256 "7ec5e677cf2fa8ddc901f347725b05b36b11901414b716af8687c3ea2a87c4fe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c65d3c5b5a63c86a8bb0bb3bbccc9fc08c881364d96386c78544da218daaa932"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c16dc1f2793fb299da7f921467b5b2fc745365ee000822ad5430c54c5cc439b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e08d5cad03ad373bf1a8b85c148a9dad2a973822033328b413bd6d2a2a3478ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "66d3260f61b799a8faf6529a588a483e11b78d77c857856f392c679b0f046449"
    sha256 cellar: :any_skip_relocation, ventura:       "c244db771bfa6c372ed2eac9ee66754f829c375b8e170ebe3bcab99cf9177ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43bff844b063dbf162af7b5c26aef3cc4a1d63ab9ccbbd406870990318c47e5c"
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