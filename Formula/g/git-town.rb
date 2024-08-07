class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv15.0.0.tar.gz"
  sha256 "996f4031f0b0f27638359f341347b710209fbb35af2433a9917368c04bcb68db"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dfa13184ac74607215abd901c4aeeea109f84ed215f84920628be9063e4d3fb4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "091a2102554c5867a5e847429dad9bac0e3ac26de8a64cd9ebadd80d4616a75c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10385f155e599b2c173bce87caefdecb17226b7cc6ca51a5f48367763284c062"
    sha256 cellar: :any_skip_relocation, sonoma:         "750be2c49861ca7cd2b53012d5ba8eb841cfa86021ed4e94e687f188d7a1a630"
    sha256 cellar: :any_skip_relocation, ventura:        "a6ebedc4536f65ccb0c9269377411080cd9a75042b83c21d08db3fe4ea9703e9"
    sha256 cellar: :any_skip_relocation, monterey:       "725d05c3d16aa24ff1549fb2e26abf90a73ff5f7783509676ee2378375c48b50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb4e972ce391ff43bff7ac76aa866357b0fc8c11046c21aab4048821f38044c9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgit-towngit-townv#{version.major}srccmd.version=v#{version}
      -X github.comgit-towngit-townv#{version.major}srccmd.buildDate=#{time.strftime("%Y%m%d")}
    ]
    system "go", "build", *std_go_args(ldflags:)

    # Install shell completions
    generate_completions_from_executable(bin"git-town", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}git-town -V")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin"git-town", "config"
  end
end