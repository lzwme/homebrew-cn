class Z < Formula
  desc "Tracks most-used directories to make cd smarter"
  homepage "https:github.comrupaz"
  # Please don't update this formula to 1.11.
  # https:github.comrupazissues205
  url "https:github.comrupazarchiverefstagsv1.12.tar.gz"
  sha256 "7d8695f2f5af6805f0db231e6ed571899b8b375936a8bfca81a522b7082b574e"
  license "WTFPL"
  version_scheme 1
  head "https:github.comrupaz.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5f891b4ed62bd2badf5baf02297e69fde253b3a7906679e3241845d3e45efab0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a753b2821b5ad33c549efc1a6f857b33e6b9db2ece6ef10f03a6811c8690544f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a753b2821b5ad33c549efc1a6f857b33e6b9db2ece6ef10f03a6811c8690544f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a753b2821b5ad33c549efc1a6f857b33e6b9db2ece6ef10f03a6811c8690544f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0b418e43748f1185408f2e948df304a58d662ee0ec41489ba5b603f56e24bbb6"
    sha256 cellar: :any_skip_relocation, ventura:        "0b418e43748f1185408f2e948df304a58d662ee0ec41489ba5b603f56e24bbb6"
    sha256 cellar: :any_skip_relocation, monterey:       "0b418e43748f1185408f2e948df304a58d662ee0ec41489ba5b603f56e24bbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a753b2821b5ad33c549efc1a6f857b33e6b9db2ece6ef10f03a6811c8690544f"
  end

  def install
    (prefix"etcprofile.d").install "z.sh"
    man1.install "z.1"
  end

  def caveats
    <<~EOS
      For Bash or Zsh, put something like this in your $HOME.bashrc or $HOME.zshrc:
        . #{etc}profile.dz.sh
    EOS
  end

  test do
    (testpath"zindex").write("usrlocal|1|1491427986\n")
    testcmd = "binbash -c '_Z_DATA=#{testpath}zindex; . #{etc}profile.dz.sh; _z -l 2>&1'"
    assert_match "usrlocal", pipe_output(testcmd)
  end
end