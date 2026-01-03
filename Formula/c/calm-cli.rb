class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.26.0.tgz"
  sha256 "7d03764af75857fc2d53c3a14d3e0ebeed260af5fbd173d30d493816f70077ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aa92ab0835e53a7f654e9e1d4b724e4741f421f91b1a6285f4921225e772a988"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    resource "testdata" do
      url "https://ghfast.top/https://raw.githubusercontent.com/finos/architecture-as-code/refs/heads/main/calm/getting-started/conference-signup.pattern.json"
      sha256 "26bb2979bb3e8a3a8eea2dfe0bd19aaa374770be61ee42c509c773c2fcc6c063"
    end

    testpath.install resource("testdata")
    system bin/"calm", "generate",
                       "--pattern", "./conference-signup.pattern.json",
                       "--output", "./conference-signup.arch.json"
    system bin/"calm", "validate",
                       "--pattern", "./conference-signup.pattern.json",
                       "--architecture", "./conference-signup.arch.json",
                       "--output", "./conference-signup.validate.json"

    assert_match version.to_s, shell_output("#{bin}/calm --version")
  end
end