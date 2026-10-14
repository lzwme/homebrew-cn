class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.62.0.tgz"
  sha256 "1055704d5bd7993fe0d966754b224e8c2301de4c259e667c6d5e0089fb92a854"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d24430763106f74fb3f32c2dad9a935fe73496a93254561209da85f0b86a8adc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d24430763106f74fb3f32c2dad9a935fe73496a93254561209da85f0b86a8adc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d24430763106f74fb3f32c2dad9a935fe73496a93254561209da85f0b86a8adc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a15f274f91121750abeb06acdc2b0a1c71fe4482b29a4b3ed35922dc5df2d906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6c7de8c07579e4718b8afc2870d3855b3713423ad63fe57af6e90f7e779068f6"
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