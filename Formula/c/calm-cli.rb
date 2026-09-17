class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.60.0.tgz"
  sha256 "f0a287f464ae9c9f52c3d94e3840e0fa8c7646aee24c57d5806e17f9eb7409fe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "66f2665957d4a6009768cefa2b4c3804b7ccb71558a66707cb2d0ca4e50eb604"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "66f2665957d4a6009768cefa2b4c3804b7ccb71558a66707cb2d0ca4e50eb604"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "66f2665957d4a6009768cefa2b4c3804b7ccb71558a66707cb2d0ca4e50eb604"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1e5cdc1d33154acc87cf5f8e2cee622d148637c1a90b0a56479966f6da3c60a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8fe7809efe30a2cb962e332ceda70ba9f7c67adf4d6f318b7276af545fd8cf6a"
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