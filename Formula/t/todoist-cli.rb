class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.70.0.tgz"
  sha256 "3a22dcb919c3e14b4a0d52084e3881af50b151a5e945a75f0b0b74ca66e69712"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd1d82d98183aefac9adfac17851adf40f612e3989c11fbc170c4a947d55fa15"
    sha256 cellar: :any,                 arm64_sequoia: "0ff6e23228b5d4f46944151280968166abd8c48c09d5bd484db57fa92fb12f26"
    sha256 cellar: :any,                 arm64_sonoma:  "0ff6e23228b5d4f46944151280968166abd8c48c09d5bd484db57fa92fb12f26"
    sha256 cellar: :any,                 sonoma:        "af10ba2d6568ba399bdfb1c8487c93755722b0197052571f436f08b08536ceff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c8ad4aac1606a39e9772276721311f91137b1e65157272e632cbd038e8d28fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efaa878369f96246d1b54a628348c8d239ca38c7d154236c230441904a6d0b83"
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