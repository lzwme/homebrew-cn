class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.66.0.tgz"
  sha256 "d13b442958c0763922c16617e0018e374bfacbe9da59680d6a5e443e9b12a322"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fb941099328de4054696dad482a1388d609690e6175524aefbb496b2e927b51a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fb941099328de4054696dad482a1388d609690e6175524aefbb496b2e927b51a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fb941099328de4054696dad482a1388d609690e6175524aefbb496b2e927b51a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e869745e355d51f7bfb612c7e7b612a9007f19c6384cac546b2ef2d117803c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c8996b0458ed4ebca25b8b3e25aeba560fc8ac8b1dffaa93543e167c59a40f30"
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