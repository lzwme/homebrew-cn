class CalmCli < Formula
  desc "CLI allows you to interact with the Common Architecture Language Model (CALM)"
  homepage "https://github.com/finos/architecture-as-code/tree/main/cli"
  url "https://registry.npmjs.org/@finos/calm-cli/-/calm-cli-1.48.0.tgz"
  sha256 "c33aba76bf064c49db81df54d542eadd3173d200d6943c3b9704fd2659d53c41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d616d2e0d2f6fc83434d01f2f5e4425c350c7a29a8c890306dce3dd1bc7a58e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d616d2e0d2f6fc83434d01f2f5e4425c350c7a29a8c890306dce3dd1bc7a58e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d616d2e0d2f6fc83434d01f2f5e4425c350c7a29a8c890306dce3dd1bc7a58e"
    sha256 cellar: :any_skip_relocation, sonoma:        "b71bfaf40a61c528140fd4423ebbfcb17558c94af2c76cefc6b78bf35c9878fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eea44af8cbd5a385ae20ef579d494a1a8bb92d98a8cc9313565c8940c50c96fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "216a852963aa67b71b6e1538ce7ddf07b73a2333b798ae671d8d4497cbcd2778"
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