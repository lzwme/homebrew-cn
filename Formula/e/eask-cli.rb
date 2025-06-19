class EaskCli < Formula
  desc "CLI for building, running, testing, and managing your Emacs Lisp dependencies"
  homepage "https:emacs-eask.github.io"
  url "https:github.comemacs-easkcliarchiverefstags0.11.6.tar.gz"
  sha256 "66faf98d76e6c6ca9b38f7721ef4aeba251181bc0aef4c692cf6d09a8988c896"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9676d69666ce4d2791896e92953bf91abe142a61584515b227fca15ef0111026"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}eask --version")

    system bin"eask", "create", "package", "test-project"
    assert_path_exists testpath"test-project"
    assert_match "Emacs is not installed", shell_output("#{bin}eask compile 2>&1")
  end
end