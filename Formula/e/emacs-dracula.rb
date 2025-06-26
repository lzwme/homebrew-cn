class EmacsDracula < Formula
  desc "Dark color theme available for a number of editors"
  homepage "https:github.comdraculaemacs"
  url "https:github.comdraculaemacsarchiverefstagsv1.8.3.tar.gz"
  sha256 "6650e5c83c419878785f555f8a23717b37eb50f897e95eedd9142f4a8d7ed616"
  license "MIT"
  head "https:github.comdraculaemacs.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fdd1a29498717bebf1d4eda6f8fdd4645d05d59a62c218407c5a32904780c97e"
  end

  depends_on "emacs"

  def install
    elisp.install "dracula-theme.el"
  end

  test do
    system "emacs", "--batch", "--debug-init", "-l", "#{share}emacssite-lispemacs-draculadracula-theme.el"
  end
end