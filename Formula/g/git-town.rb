class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv14.4.1.tar.gz"
  sha256 "8614df3c9906bfdf68ac0ce24a369e94b7bf65f134146eddff4c5d052e283a49"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae6db59819154514e6bc310721066156b6303bec3e75c994e77492bacb3295b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a117f5e509965d3459b1dd361e144f0ca299dfa8049310035664903d71e962e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd5d0917219d268f3239585e622af51e4306478e4b30c3061786a8356ca68abf"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4dab4f16ef146d9403b8010919004f6bdf54c41961d61cc60ec7d35df11beac"
    sha256 cellar: :any_skip_relocation, ventura:        "801731e490e04fff988d015f02be8d7831cf3f45e7d523803663dc0f99e4f2ad"
    sha256 cellar: :any_skip_relocation, monterey:       "c5be75c10878e6a3a419701cc22c098decc2e1a308c9f85141c9e687c2027499"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d748ef1a0bb45753f043676ae5178de591fcc5c31aaa10b95d2de6dfd91d4ca"
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