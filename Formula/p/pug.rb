class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https:github.comleg100pug"
  url "https:github.comleg100pugarchiverefstagsv0.5.1.tar.gz"
  sha256 "1287ba25924ce593c20d6537b5a14e854bf16c9f433f83bc7ea344c62870ccb1"
  license "MPL-2.0"
  head "https:github.comleg100pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4573eeedf5490a82cc60d450511ef2d652432db1b5a62249bf95bcaec220f97a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "393c61ef762f7e69212602573bf7ac529da1c0d76cf45c9245045f8d4966e605"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "393c61ef762f7e69212602573bf7ac529da1c0d76cf45c9245045f8d4966e605"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "393c61ef762f7e69212602573bf7ac529da1c0d76cf45c9245045f8d4966e605"
    sha256 cellar: :any_skip_relocation, sonoma:         "03f6e374300f5a14efa826b6e5b6747b981600542f6f28f6c84b7931b8ad6777"
    sha256 cellar: :any_skip_relocation, ventura:        "03f6e374300f5a14efa826b6e5b6747b981600542f6f28f6c84b7931b8ad6777"
    sha256 cellar: :any_skip_relocation, monterey:       "03f6e374300f5a14efa826b6e5b6747b981600542f6f28f6c84b7931b8ad6777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fb702e3e0d7ef83068011a3260385a777c48c6e87dc4225d75a7dff1c1025f8"
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