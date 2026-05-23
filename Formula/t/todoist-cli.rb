class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.67.0.tgz"
  sha256 "01af96e12d7c81e141b759957f2aa12193ed7f361267d06234cfefe1a0cdebca"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "111fa9d7c1d1b55c093a2b3e014c5432ac2e6cd7dc437cca63de478b839e99bf"
    sha256 cellar: :any,                 arm64_sequoia: "e30a76124475473e42143bc698fe69c9a1f1e6c193839b83a016f42ec3b39c32"
    sha256 cellar: :any,                 arm64_sonoma:  "e30a76124475473e42143bc698fe69c9a1f1e6c193839b83a016f42ec3b39c32"
    sha256 cellar: :any,                 sonoma:        "99c2b2748806564d70b5518b10b060bb10cd07ebee55118bc40c7727ada90c6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1696a336a1122b910d991fd4f410bcce227edf21cec753d0a22714f1a638f3aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84015f9d894c3e64e39d8ddd194526f0017621715e69e2af40369c033685bdb7"
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