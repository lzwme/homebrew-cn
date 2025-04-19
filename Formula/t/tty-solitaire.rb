class TtySolitaire < Formula
  desc "Ncurses-based klondike solitaire game"
  homepage "https:github.commpereiratty-solitaire"
  url "https:github.commpereiratty-solitairearchiverefstagsv1.4.0.tar.gz"
  sha256 "5f07d5a3f457c5617699f3360d6c85dc3d1d9a492a68656060c3d66bd9f36640"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b0a572930cee2dcbc893443b9ece421cb7b3f9e6bdf999899ac1b84a43d224e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "084621db3ab3898d093029f5f825fba4adcdc4232481520cfec025972fb4f04b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c0d491df5a3209118a5a11662bea7b27983aef7f9d460609cc2ac4f645cff2f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8ce0eaf157691b697f0314f55a7c9c4828202b31d318af7bfac122cf24085905"
    sha256 cellar: :any_skip_relocation, ventura:       "38ec02d04458902e2c55ac898d4a02c56a9245b968530e20eb8cbd7659c57354"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b20244f58fd053d484bd02e9c6f6d6b2ef6597b9cbdbc1e7043d421d01a781ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77c1dcb632642846e33ee43800fd61b8faffc497769cb80bb4fd1ae8ea238a5f"
  end

  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin"ttysolitaire", "-h"
  end
end