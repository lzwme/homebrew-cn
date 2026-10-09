class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.61.0.tgz"
  sha256 "6ab28119cc3fdc43e3fbf329790fe45f96ce87e896d6c3cfcde718a975dde86e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f1abf71c514e6ff8e288e67fe459e051cb10bcc8a84e0802d32b682016a496d6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f1abf71c514e6ff8e288e67fe459e051cb10bcc8a84e0802d32b682016a496d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f1abf71c514e6ff8e288e67fe459e051cb10bcc8a84e0802d32b682016a496d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "562cbb13b49ec485ef5ae1f65faf760a1b02507367141e14e1baa8a0c90035a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e0fe59321014b37a19723b4171447c5584ee1e928751008d5f5c39d4b2aadaf0"
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