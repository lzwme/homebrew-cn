class Murex < Formula
  desc "Bash-like shell designed for greater command-line productivity and safer scripts"
  homepage "https:murex.rocks"
  url "https:github.comlmorgmurexarchiverefstagsv6.1.8300.tar.gz"
  sha256 "7d84fcb03c59e7f8f848713f1a464a3212d24311ddc733da0db65c27e7d1488f"
  license "GPL-2.0-only"
  head "https:github.comlmorgmurex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ba75743647a87370aad957b1c4877b51e6da0967c773c8b3f6d327f27ee18ec5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae664c4c3511600cb624997f40fd0700c124682f0432c7436448a28c50d5760c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c261fa2bb9f05e7d3b9d2d2edbb8549280e40bc07f70a8fb1db172c61e34742"
    sha256 cellar: :any_skip_relocation, sonoma:         "04d780fd52634a217e40d4ba57bbaf09d98e915971fa21bad4eb7baa64172318"
    sha256 cellar: :any_skip_relocation, ventura:        "b56dc474b069ff5c20f6955c7921a800d899b8d6725cac67c3f8a2a30a8b8144"
    sha256 cellar: :any_skip_relocation, monterey:       "5cb663013a03209719bbc0ccfe589af692d4a7d9afc8adc89697fba3b6244616"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3817707b8c33a254ed62eb51593d5e7b97f85aac1a8d38c31618535b1cfeb592"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_equal "homebrew", shell_output("#{bin}murex -c 'echo homebrew'").chomp
    assert_match version.to_s, shell_output("#{bin}murex -version")
  end
end