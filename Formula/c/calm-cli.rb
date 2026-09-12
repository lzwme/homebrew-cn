class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.59.0.tgz"
  sha256 "787a5e9eccee59232c48d09e307119b65fb5a320b48169e2ab03c8764d0460e9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cef9e3dd5489167c1bda4ef5f4e1b15267613fe50e09654771102fb36e3696a9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f6bf87443af1d59c17df5d7268f237126a06c0f0e6721c75e6ada48dc29979f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f6bf87443af1d59c17df5d7268f237126a06c0f0e6721c75e6ada48dc29979f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "f6bf87443af1d59c17df5d7268f237126a06c0f0e6721c75e6ada48dc29979f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c203cc1cba28e19ace36a0c7eebdb1417f5d8b0174d413ff865f9489157050c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "90c200986919afb8280aadf5c82a8c321476f1c3694743cadfd36fd70c46e3c3"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    resource "testdata" do
      url "https://ghfast.top/https://raw.githubusercontent.com/finos/architecture-as-code/717350bec736a7f931c7c09df6b0b0b56e51612f/calm/getting-started/conference-signup.pattern.json"
      sha256 "26bb2979bb3e8a3a8eea2dfe0bd19aaa374770be61ee42c509c773c2fcc6c063"
    end

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