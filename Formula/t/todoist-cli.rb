class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.69.3.tgz"
  sha256 "74df44470100c9a5baece7b5198dec9b9f8fb416eee0a5b86178559ec39dfeb3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "302457c04bfa501cc1e36fe9cc608d8d732272e410b029bd22708a7a0223f693"
    sha256 cellar: :any,                 arm64_sequoia: "5a28a34860fa63b41714b061a0196e41553bdbe449e49d98fe8e2438c2542b2c"
    sha256 cellar: :any,                 arm64_sonoma:  "5a28a34860fa63b41714b061a0196e41553bdbe449e49d98fe8e2438c2542b2c"
    sha256 cellar: :any,                 sonoma:        "14f365d6f3a5fb80e84f85aa02b052fae094635aab0e6cf97ece48ae8470fcbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3edd7885421eeebb16a37be007f696e160d9cb3d9bddf51c8eddd3a39304f2f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "335eed1f755dee7df7f7353856fdb709951fabd74ec4393f9a47a7aff45a9d47"
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