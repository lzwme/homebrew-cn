class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.0.2.tgz"
  sha256 "8692b3d12149368aec5d5b62eb8bc28c2280a2e826412bad1c984110d313073f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c77223b28912459f6c3219fa6ed5f922ed411bb5d551256e00ccf3e8100add5f"
    sha256 cellar: :any,                 arm64_sequoia: "c77223b28912459f6c3219fa6ed5f922ed411bb5d551256e00ccf3e8100add5f"
    sha256 cellar: :any,                 arm64_sonoma:  "c77223b28912459f6c3219fa6ed5f922ed411bb5d551256e00ccf3e8100add5f"
    sha256 cellar: :any,                 sonoma:        "42af0e6c054bbf565f064bb36b16c703ee4cd26f7d88dd3ef6cee4a77241731a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1dde44bfe0b5fd75d99484eccba11ac7e1a69f0f5c93c9f56b36300897b7cb91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8232861260ba2ce06d097bfa6071f9dc4ec4a57de4a488e7ecae68187115a9df"
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