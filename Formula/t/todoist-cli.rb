class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.74.0.tgz"
  sha256 "8be746f4fde51569c0a62190c9d0abbe8e111c1607ebe7a40fd98e68dbe2e89b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07a170797e89a5e05443f4470c89535ad0b4ee4cfd6cef51f0dc6a9e7fc48331"
    sha256 cellar: :any,                 arm64_sequoia: "c295eb6f0b834c1d330e0c5d504407983d984d80f1c13fcc08ab81e099dbaa1e"
    sha256 cellar: :any,                 arm64_sonoma:  "c295eb6f0b834c1d330e0c5d504407983d984d80f1c13fcc08ab81e099dbaa1e"
    sha256 cellar: :any,                 sonoma:        "970cd41a88e3a4d8ab92d539586f4f4aaf06f3134e3e2b0a0672faaaa1b8e8e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f75b219e1e6c89a87f7c6ef37eca970dbb16e5a99afa6ad7188a6a725f54813"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c207ca843eec4f176e8971d855e1c21a2344c75935d93361db684919a1cca2da"
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