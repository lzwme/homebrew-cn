class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https:github.comleg100pug"
  url "https:github.comleg100pugarchiverefstagsv0.5.0.tar.gz"
  sha256 "6da025d5114db9b4029b3e55e5adb92c518c10421ccfcb95ed1c732133ae7911"
  license "MPL-2.0"
  head "https:github.comleg100pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f80c45a4c4dc797d12b326d5b0cb7add196d479dff5933f8d4eb11053fbd6a9b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f80c45a4c4dc797d12b326d5b0cb7add196d479dff5933f8d4eb11053fbd6a9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f80c45a4c4dc797d12b326d5b0cb7add196d479dff5933f8d4eb11053fbd6a9b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1da98a97d7548e7e1a02172c294ff92e24b45cbf7fed7b95f6ce8bc561ddd29"
    sha256 cellar: :any_skip_relocation, ventura:        "a1da98a97d7548e7e1a02172c294ff92e24b45cbf7fed7b95f6ce8bc561ddd29"
    sha256 cellar: :any_skip_relocation, monterey:       "a1da98a97d7548e7e1a02172c294ff92e24b45cbf7fed7b95f6ce8bc561ddd29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb136d42e1fc59e032ba2704fddd5afb806ba8ecf921123b4064f0a415cc9187"
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