class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.2.0.tgz"
  sha256 "a2684d639ee1d11929c1056aaf0e30e6c4ef831262f0f8b3f4b5e80f6aeda6c6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "29e43d29bf0f92900211fda9a94152ed71f35641d186312d7363fcfaec997e31"
    sha256 cellar: :any,                 arm64_sequoia: "29e43d29bf0f92900211fda9a94152ed71f35641d186312d7363fcfaec997e31"
    sha256 cellar: :any,                 arm64_sonoma:  "29e43d29bf0f92900211fda9a94152ed71f35641d186312d7363fcfaec997e31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3f6bcbdc722e922cd5a2609588af4a1e8cdffa51f6a4399b53a3463befe8391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a32548670009dc6b57c84f15c0bb13ed5e8190906b992a69b3fad734a540503"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    deuniversalize_machos libexec/"lib/node_modules/@doist/todoist-cli/node_modules/app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end