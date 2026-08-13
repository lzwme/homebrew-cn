class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.1.8.tgz"
  sha256 "00ec0edf5fc18cc2839ea65bfe5e3cdf639f78bf30c5b1d0dc4e5dbbef73117f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eb9ada368568b11ac06583d757a1bde860da5a59b8975711081e3eb16a26744c"
    sha256 cellar: :any,                 arm64_sequoia: "eb9ada368568b11ac06583d757a1bde860da5a59b8975711081e3eb16a26744c"
    sha256 cellar: :any,                 arm64_sonoma:  "eb9ada368568b11ac06583d757a1bde860da5a59b8975711081e3eb16a26744c"
    sha256 cellar: :any,                 sonoma:        "02f995791b217cf5b5c8791fdb9d3d9417c7d5e72fd97585e3c46cc2f074dff6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5fe058107bae0b6f1da479ec0d8c6f31bfe1c99ad5cfa80c0cbbca6819cfc5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e69cd8117c580f5d23b5bf485f7851fa90701d4cdfa97dca2c7e66acce92062"
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