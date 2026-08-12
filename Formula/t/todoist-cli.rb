class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.1.7.tgz"
  sha256 "f2492c52b0fda7512085aa64c9bcebce6062f56acd49de4384206363994cb7c0"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1a3d0d3db44bd3180cb46c040e872a8c468365e895ada74a8a4cbd7c216e55ff"
    sha256 cellar: :any,                 arm64_sequoia: "1a3d0d3db44bd3180cb46c040e872a8c468365e895ada74a8a4cbd7c216e55ff"
    sha256 cellar: :any,                 arm64_sonoma:  "1a3d0d3db44bd3180cb46c040e872a8c468365e895ada74a8a4cbd7c216e55ff"
    sha256 cellar: :any,                 sonoma:        "c5402ca8b6c03e478f386f32071f022f3b41d6d16ae463e63ed155e1aad42eb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fac2ad66f566f985133855e149b11da6a0651c8ffe3e32d7538d73dca76dfdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a0a77d452ce402214bf9b314c61564defcc10397b147cd504cae8f6add1f381"
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