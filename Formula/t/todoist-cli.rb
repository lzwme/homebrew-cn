class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.0.6.tgz"
  sha256 "bd049743482513c16d579d7660619f8e0c9b5298a166185ed5c6b674625379a9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b86eb350c7f0c54fbbbb8ae667e1b8b2771033492d41b878d3dab873f13da901"
    sha256 cellar: :any,                 arm64_sequoia: "b86eb350c7f0c54fbbbb8ae667e1b8b2771033492d41b878d3dab873f13da901"
    sha256 cellar: :any,                 arm64_sonoma:  "b86eb350c7f0c54fbbbb8ae667e1b8b2771033492d41b878d3dab873f13da901"
    sha256 cellar: :any,                 sonoma:        "7086c18aa2e64fb7317be641c7751de5f03bd8d38087b616fe9ba19f3e9d74f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3acdff7b29ed6d1f3dca649510693946143a20f56673a508be6d2969acd47684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1225e5503ace1cf16a2ad194a78f6f1cd2c188f57000411f2eaeb9cf8dc35be3"
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