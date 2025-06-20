class EaskCli < Formula
  desc "CLI for building, running, testing, and managing your Emacs Lisp dependencies"
  homepage "https://emacs-eask.github.io/"
  url "https://registry.npmjs.org/@emacs-eask/cli/-/cli-0.11.6.tgz"
  sha256 "79b6d030347f2bebeec9e4d88b0743722e8667edcd126ebb9c93178ab4973a0a"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9676d69666ce4d2791896e92953bf91abe142a61584515b227fca15ef0111026"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eask --version")

    system bin/"eask", "create", "package", "test-project"
    assert_path_exists testpath/"test-project"
    assert_match "Emacs is not installed", shell_output("#{bin}/eask compile 2>&1")
  end
end