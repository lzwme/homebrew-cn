class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.1.9.tgz"
  sha256 "61f40d8fdbc08e8316c311393c9fabf2258adb69ec64092136cb56868f30f234"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1aec5f5d85d1f4572b1c8c65b4830e993f7c45eff8247211cdb90ee0989700ac"
    sha256 cellar: :any,                 arm64_sequoia: "1aec5f5d85d1f4572b1c8c65b4830e993f7c45eff8247211cdb90ee0989700ac"
    sha256 cellar: :any,                 arm64_sonoma:  "1aec5f5d85d1f4572b1c8c65b4830e993f7c45eff8247211cdb90ee0989700ac"
    sha256 cellar: :any,                 sonoma:        "80a0d80e16e73ba103a53ee0b272b6164b67f428c16563741cd61a600c8060b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b2fa410d10a3952019fd6003cfd4918483b6af37015ffaa3b6400bad2813388b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fc28f984a3958d1db6983d851a117e028dd123edb4d0323036a8582987dd0b2"
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