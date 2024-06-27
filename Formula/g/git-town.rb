class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https:www.git-town.com"
  url "https:github.comgit-towngit-townarchiverefstagsv14.2.3.tar.gz"
  sha256 "e945bc04a1f7e66b76571dd644f5d92dff400bf23d014714cd513cd30387fa65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51c99e654f9def0f3b069309568366c52f8c230175e19b54f1cedbf022304d50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10bc22014409b66dcbb892e47055a01825c5dcd2c5466375947d545b2be42008"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afa4694262494d781bcadaf6cff96dda45a23cf452bde5003eb3fe91f6085a20"
    sha256 cellar: :any_skip_relocation, sonoma:         "5b40b985fd4c207bb0fb851de7fbf8fe58d0a423de920cbf9e56dc08500e077b"
    sha256 cellar: :any_skip_relocation, ventura:        "7cd0ffce91b3ee1b99311ee6f042bfabec44aa08da49659628da157fb1cfd95c"
    sha256 cellar: :any_skip_relocation, monterey:       "e39b2c7813ddf096d2c8100c4faa64ceaf7c2a8436482bb064c9e8daa2c3d04a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5479dd4c54ea7c366a699668e4d6448e073eec522c09702dd97640fa6f987c0"
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