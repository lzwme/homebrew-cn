class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.118.4.tgz"
  sha256 "3251bb61e05c226cd790462b96957a3cd66e846603e5e62512f9092b613b1b2d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1c1aca89ff6cc45c8d7c2abe94ab7da301b00c539d8890513a02d6cc50f491f8"
    sha256 cellar: :any,                 arm64_sonoma:  "81112659d60f01421c9bb75afd0d080d0897f17207f09fa06717d2af4d7922cd"
    sha256 cellar: :any,                 sonoma:        "1695284257c4b8bbf5db38c4c71166c7a3c4acd61ec7c9a6ddbb475871986ff3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3705b14b05b1930369ead38df24543aaad29433dc6d54ed781de280c063016c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9837f915c8c663517cbb1afabb7772f051544b9bb70c871198f62d91a048279e"
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