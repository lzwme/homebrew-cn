class Lazygit < Formula
  desc "Simple terminal UI for git commands"
  homepage "https:github.comjesseduffieldlazygit"
  url "https:github.comjesseduffieldlazygitarchiverefstagsv0.47.1.tar.gz"
  sha256 "04ae15c6aa2929e083eac8ff010a5a66e5ae566e5157893e4929d3a6bd519649"
  license "MIT"
  head "https:github.comjesseduffieldlazygit.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed0c89c5dcfc3b2732a7309ed654c0461f3d398665e2bebdb35190d8eb8b95cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed0c89c5dcfc3b2732a7309ed654c0461f3d398665e2bebdb35190d8eb8b95cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed0c89c5dcfc3b2732a7309ed654c0461f3d398665e2bebdb35190d8eb8b95cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f150cfc9df514b34967614e7ee00fae903548d1db737a5f558ebaec639259861"
    sha256 cellar: :any_skip_relocation, ventura:       "f150cfc9df514b34967614e7ee00fae903548d1db737a5f558ebaec639259861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "565936808c1aac929eb50715404992df73a104bc47cc601a88b7944bdfe4a117"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.buildSource=homebrew"
    system "go", "build", "-mod=vendor", *std_go_args(ldflags:)
  end

  test do
    system "git", "init", "--initial-branch=main"

    output = shell_output("#{bin}lazygit log 2>&1", 1)
    assert_match "errors.errorString terminal not cursor addressable", output

    assert_match version.to_s, shell_output("#{bin}lazygit -v")
  end
end