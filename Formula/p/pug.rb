class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https:github.comleg100pug"
  url "https:github.comleg100pugarchiverefstagsv0.4.2.tar.gz"
  sha256 "6cb29112b8198798fdf6decad3edf5f85e8674fe1269ba93068467ae8a37d281"
  license "MPL-2.0"
  head "https:github.comleg100pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "45452e550739d23ccb8191db0d121b7066c639fda6030fb952e499620f100dab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "618f032be2455e297f8252ccc4a721abe3e482f2d7898787dc6c5c876f68281e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76aae9bb4d21d62cb1e4a1b0e7c75340f59d64f5eff59164abcc2a54c4965216"
    sha256 cellar: :any_skip_relocation, sonoma:         "ec4306ed70160d848b389f0cabcbaa21e1a62ca0b395dd7f3716bd581faf9967"
    sha256 cellar: :any_skip_relocation, ventura:        "7100a195649746952db8703957e206aeb3e5c69f2a9267178c4afc680a2f0e63"
    sha256 cellar: :any_skip_relocation, monterey:       "e4be09021cdd9d1d6b745abaa2e4e8b584fd62e065ceca6389830b7ea4568cb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac6878b887c18b79d8abe42f1287c3d544db1c905fa638c7ad592ab0e14dbfbd"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.comleg100puginternalversion.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    r, _w, pid = PTY.spawn("#{bin}pug --debug")
    # check on TUI elements
    assert_match "Modules", r.readline
    # check on debug logs
    assert_match "loaded 0 modules", (testpath"messages.log").read

    assert_match version.to_s, shell_output("#{bin}pug --version")
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end