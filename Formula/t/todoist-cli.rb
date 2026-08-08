class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.1.4.tgz"
  sha256 "f7d75e9902af0a1d698dfaf4ce94a333ffbda71c8f3ee849121a2556ca582330"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d979509988c26a08c03da168ff18469232118796ffa7a45db082db89030772c7"
    sha256 cellar: :any,                 arm64_sequoia: "d979509988c26a08c03da168ff18469232118796ffa7a45db082db89030772c7"
    sha256 cellar: :any,                 arm64_sonoma:  "d979509988c26a08c03da168ff18469232118796ffa7a45db082db89030772c7"
    sha256 cellar: :any,                 sonoma:        "e124eca2bb609740f713e6428caf7944453f4616730333e2cd7f4637f91b3bf8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d47266c350342d4662f0179251dae0f4fbd2dd8cce5547d4e73b98920ea2dd68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "08947c13ba2e6d0cb24a7705c0c65bc9da799c3eb823cb4dfafc463771dc025b"
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