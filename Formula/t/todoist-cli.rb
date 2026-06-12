class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.73.4.tgz"
  sha256 "a670fcc599c43766081f67397c29125097410e59f07035063d891c1c46a8660d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ac78013664076b4398af63082ae07b484a74723ff97359be8a1b78db1a70c2e"
    sha256 cellar: :any,                 arm64_sequoia: "2307742bb011e3baa23eff13e4bcbe089e593e1ea57a15d51fe6975a81f103ce"
    sha256 cellar: :any,                 arm64_sonoma:  "2307742bb011e3baa23eff13e4bcbe089e593e1ea57a15d51fe6975a81f103ce"
    sha256 cellar: :any,                 sonoma:        "bfe8312dcce897c210152f3c400a4c4ea7b4ee654e3a49963309b3e812577da6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15db07ab8a1031cf1835288c9abf3b8dbc17b808d4f2f2ed38878def72233582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c438781fcda33babc2196c727902b8b259ad5692da058b9ca8507eb968030ae4"
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