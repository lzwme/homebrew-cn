class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.63.0.tgz"
  sha256 "3936059d8ba60c44117048f656da92e4e6366c597ff64b3752bf1408dff49467"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5fe1178faee7d4852cc2ddb24ca9e357ac584c76f689d42fa982ebb30654d548"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5fe1178faee7d4852cc2ddb24ca9e357ac584c76f689d42fa982ebb30654d548"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5fe1178faee7d4852cc2ddb24ca9e357ac584c76f689d42fa982ebb30654d548"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "76e6a90235e05835fda53f74484ef737c0cf25c4e91208063e1f775553a143cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "00374d7afb297de790a1ca7e01607baa01f60b5ad6e49925400f1f1d651e9f2a"
  end

  depends_on "node"

  resource "testdata", :test do
    url "https://ghfast.top/https://raw.githubusercontent.com/finos/architecture-as-code/717350bec736a7f931c7c09df6b0b0b56e51612f/calm/getting-started/conference-signup.pattern.json"
    sha256 "26bb2979bb3e8a3a8eea2dfe0bd19aaa374770be61ee42c509c773c2fcc6c063"
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    testpath.install resource("testdata")
    system bin/"calm", "generate",
                       "--pattern", "./conference-signup.pattern.json",
                       "--output", "./conference-signup.arch.json"
    assert_match "conference-website", (testpath/"conference-signup.arch.json").read
    # TODO: restore `--architecture` roundtrip once upstream `generate` emits the `control-id` required since 1.50.0
    system bin/"calm", "validate",
                       "--pattern", "./conference-signup.pattern.json",
                       # "--architecture", "./conference-signup.arch.json",
                       "--output", "./conference-signup.validate.json"

    assert_match version.to_s, shell_output("#{bin}/calm --version")
  end
end