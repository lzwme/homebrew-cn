class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.0.4.tgz"
  sha256 "5a09ed8ca5d6aec8ff6d135d5d87ff63a6e62ec8b83e5472377742d85c960c38"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "58eb1c0b87b6286d54cf959d4cf5d793603fe525346c57ff50832b115b7de547"
    sha256 cellar: :any,                 arm64_sequoia: "58eb1c0b87b6286d54cf959d4cf5d793603fe525346c57ff50832b115b7de547"
    sha256 cellar: :any,                 arm64_sonoma:  "58eb1c0b87b6286d54cf959d4cf5d793603fe525346c57ff50832b115b7de547"
    sha256 cellar: :any,                 sonoma:        "207cfa3763e2dfe81d1af95213657534c3bc580d1f5c9cb26f8b33a27af4e0ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c254238df713606f7ecd58935c6c28db87ca50daeb0ff178648a572f8499ea94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66c93a969885fc17571d1b6908dc05c68edfde2b5163761a6b8a9e9745c00bc0"
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