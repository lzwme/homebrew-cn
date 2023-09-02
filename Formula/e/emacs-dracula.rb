class EmacsDracula < Formula
  desc "Dark color theme available for a number of editors"
  homepage "https://github.com/dracula/emacs"
  url "https://ghproxy.com/https://github.com/dracula/emacs/archive/v1.8.0.tar.gz"
  sha256 "6ab6712554e06e117391d142c10223ceaa2f8af1fa9f08a76ea02111a8827510"
  license "MIT"
  head "https://github.com/dracula/emacs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "93cf60ee49ffb8616c564b8102e08d2a8cd52aaa81b8ef958fed8cbc1a8502bb"
  end

  depends_on "emacs"

  def install
    elisp.install "dracula-theme.el"
  end

  test do
    system "emacs", "--batch", "--debug-init", "-l", "#{share}/emacs/site-lisp/emacs-dracula/dracula-theme.el"
  end
end