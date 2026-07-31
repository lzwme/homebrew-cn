class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.51.0.tgz"
  sha256 "be1303f54b8208f2edd3b6bba48d79191b76d37e2f6daf1daf5ea7f1f6959775"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c16d6fc591ddffad52de40550feaf8a6c0f4646c1236630e9bf3a3e1c15e9eac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c16d6fc591ddffad52de40550feaf8a6c0f4646c1236630e9bf3a3e1c15e9eac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c16d6fc591ddffad52de40550feaf8a6c0f4646c1236630e9bf3a3e1c15e9eac"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2ff42853d58b7cfcf98eb1e4ecca1473c9559eaabfa1a0f040e0b70b8403413"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "59aa2617c665f60042e02a5bee306f4fb5229a1edad38bb2349efc58a21913d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "536c2ce15faa980934a004731e188bca03c05b15316668495e8ca07a769af55d"
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