class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.1.5.tgz"
  sha256 "a11875e10ebf020e0aa9cc17ea4ff0ed069ab95ac4f04444c336dffbdf8fdc00"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aad4c67c990e76666331b41424c852f407ab6eb6e76dfe826f9f97a4da5c916e"
    sha256 cellar: :any,                 arm64_sequoia: "aad4c67c990e76666331b41424c852f407ab6eb6e76dfe826f9f97a4da5c916e"
    sha256 cellar: :any,                 arm64_sonoma:  "aad4c67c990e76666331b41424c852f407ab6eb6e76dfe826f9f97a4da5c916e"
    sha256 cellar: :any,                 sonoma:        "2a33b1f4aceca75aff1bdb21a17540ba2d6e17a6fe206a61aafcf3f6126d380c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b3ba9695df93caeb5a107bfd218d743302c3c5de9d1d70fd1301338da05d867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8277f33a6a8fd7190c5e38b873354023c87f944023084d06e4cac7ae33b3f5dd"
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