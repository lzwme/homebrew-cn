class EaskCli < Formula
  desc "CLI for building, running, testing, and managing your Emacs Lisp dependencies"
  homepage "https://emacs-eask.github.io/"
  url "https://registry.npmjs.org/@emacs-eask/cli/-/cli-0.12.5.tgz"
  sha256 "537a104e65ff10fa55f968b627147f25e605f6f7bced6106801c3e1da8b46024"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d5c6157a786ad8fd088d237f539dacee83f19f24b9e20cce0a1a8787edc54715"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eask --version")

    system bin/"eask", "create", "package", "test-project"
    assert_path_exists testpath/"test-project"
    assert_match "Emacs is not installed", shell_output("#{bin}/eask compile 2>&1")
  end
end