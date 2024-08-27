class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https:github.comjarunnnn"
  url "https:github.comjarunnnnarchiverefstagsv5.0.tar.gz"
  sha256 "31e8fd85f3dd7ab2bf0525c3c0926269a1e6d35a5343a6714315642370d8605a"
  license "BSD-2-Clause"
  head "https:github.comjarunnnn.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7773a56db688d09ee950ed2cece939fd95d229031044acbc310eda58f227c0b7"
    sha256 cellar: :any,                 arm64_ventura:  "094d843cb5247e4140b21d3145b214ac43ec3a2aa5e366779db33369c922523c"
    sha256 cellar: :any,                 arm64_monterey: "c644255f2c961e6e4804e2c9fcecdb20a9b09cfcb226b86907c43097cf9b0c25"
    sha256 cellar: :any,                 sonoma:         "1a839e5fb6dc6049039c8148d648265f30673f8589d51f84146283148c1d2563"
    sha256 cellar: :any,                 ventura:        "142164bea2d0cbdd7984a410bd981ee718c2d7a6bd600d0d1e0361886af1530e"
    sha256 cellar: :any,                 monterey:       "9fc7ce6137ed2d0ba69d9e44524485f23a768b464a82c570e2529c84f72cb357"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46ee484c8948c2c24d8fd20f11013fbf6c1c4657d5c4659983d985f5a0e2056f"
  end

  depends_on "gnu-sed"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "miscauto-completionbashnnn-completion.bash"
    zsh_completion.install "miscauto-completionzsh_nnn"
    fish_completion.install "miscauto-completionfishnnn.fish"

    pkgshare.install "miscquitcd"
  end

  test do
    # Test fails on CI: Inputoutput error @ io_fread - devpts0
    # Fixing it involves ptyruby voodoo, which is not worth spending time on
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Testing this curses app requires a pty
    require "pty"

    (testpath"testdir").mkdir
    PTY.spawn(bin"nnn", testpath"testdir") do |r, w, _pid|
      w.write "q"
      assert_match "~testdir", r.read
    end
  end
end