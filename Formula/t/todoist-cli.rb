class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.69.1.tgz"
  sha256 "85397753258f46df6241bdd411e96659c736aa4923c611a3a2173713d6722c0a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d0ea0cf9ad7cc5f378204a8c53baac52d48c6136dc1f79f5cb6b1075e1949db6"
    sha256 cellar: :any,                 arm64_sequoia: "cd22337d98a94e8f92f5c67ee640c91d5c743eafe80281318c13ba34330560ae"
    sha256 cellar: :any,                 arm64_sonoma:  "cd22337d98a94e8f92f5c67ee640c91d5c743eafe80281318c13ba34330560ae"
    sha256 cellar: :any,                 sonoma:        "411371744142c1146c353987cf74376c7fbd765bb0fceead2dee27318a9f7c43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c7acb186123e0ca1fb3ebc61cd4703df4893e3c2221e8b67d024dd739529a4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2cd86ab210f84d78ea0c86a658395505448aaa03d71cf7dded17a4eff256381"
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