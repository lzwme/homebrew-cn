class BashPreexec < Formula
  desc "Preexec and precmd functions for Bash (like Zsh)"
  homepage "https:github.comrcalorasbash-preexec"
  url "https:github.comrcalorasbash-preexecarchiverefstags0.5.0.tar.gz"
  sha256 "23c589cd1da209c0598f92fac8d81bb11632ba1b2e68ccaf4ad2c4f3204b877c"
  license "MIT"
  head "https:github.comrcalorasbash-preexec.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bbc6178de7bf7f51abae6cba24f2a178efac44b00aa077cde3c5a2a4184a01b3"
  end

  def install
    (prefix"etcprofile.d").install "bash-preexec.sh"
  end

  def caveats
    <<~EOS
      Add the following line to your bash profile (e.g. ~.bashrc, ~.profile, or ~.bash_profile)
        [ -f #{etc}profile.dbash-preexec.sh ] && . #{etc}profile.dbash-preexec.sh
    EOS
  end

  test do
    # Just testing that the file is installed
    assert_predicate testpath"#{prefix}etcprofile.dbash-preexec.sh", :exist?
  end
end