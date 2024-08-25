class Rcm < Formula
  desc "RC file (dotfile) management"
  homepage "https:thoughtbot.github.iorcmrcm.7.html"
  url "https:thoughtbot.github.iorcmdistrcm-1.3.6.tar.gz"
  sha256 "f4fdfbc451d1fb5764531290a202a0a871f6b81ba3c01a6b76c49435c85080a5"
  license "BSD-3-Clause"

  # The first-party website doesn't appear to provide links to archive files, so
  # we check the Git repository tags instead.
  livecheck do
    url "https:github.comthoughtbotrcm.git"
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "bc964820b4e236614e4a76ea1a6913b25abbe68cfa00a106aae40944b3af8d3f"
  end

  def install
    ENV["CONFIG_SHELL"] = "binbash"
    system ".configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath".dotfiles").mkdir
    (testpath".gitconfig").write <<~EOS
      [user]
      	name = Test User
      	email = test@test.com
    EOS
    assert_match((Moving|Linking)\.\.\.x, shell_output("#{bin}mkrc -v ~.gitconfig"))
  end
end