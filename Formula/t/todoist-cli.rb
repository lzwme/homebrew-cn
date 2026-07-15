class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-2.0.0.tgz"
  sha256 "d6207777b85e6732a8cca1cf61640c5e51a6dd89611ec8602abf54cd598036eb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d303566dbe4ee78e1e3c1c976fac61367039e32e36f49ab48a39972537acddcd"
    sha256 cellar: :any,                 arm64_sequoia: "d303566dbe4ee78e1e3c1c976fac61367039e32e36f49ab48a39972537acddcd"
    sha256 cellar: :any,                 arm64_sonoma:  "d303566dbe4ee78e1e3c1c976fac61367039e32e36f49ab48a39972537acddcd"
    sha256 cellar: :any,                 sonoma:        "ba6979e7ae99ce7c644c18016677133becc0387009b0be81fb86648c477e9fd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e8d7d7f0c2a9dc71308aff320bb456811ce3f20d4713a665de1f6f312745161"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6814d69567fae65859a9996aba19adc75c03c15f7a7bce35b67bcff32ca2f353"
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