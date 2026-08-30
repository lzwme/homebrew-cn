class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.1.2.tgz"
  sha256 "ac2a6849a4072910f337fe63cfc7b131220c221884653e256422eda15b6f83a9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b48ff130dfc862ea00cc22ae3c65e0a4da87d701fa4ebf02fe6a4d56d415a62b"
    sha256 cellar: :any,                 arm64_sequoia: "b48ff130dfc862ea00cc22ae3c65e0a4da87d701fa4ebf02fe6a4d56d415a62b"
    sha256 cellar: :any,                 arm64_sonoma:  "b48ff130dfc862ea00cc22ae3c65e0a4da87d701fa4ebf02fe6a4d56d415a62b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7819eb47591f469e277c26f5a6af441ef02ba8d537fde8d126a6b2c82d1fa6da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fff082f9a038fa6939afc5783984f9d6de1c92d314250717f4aa3c5f8c26cb60"
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