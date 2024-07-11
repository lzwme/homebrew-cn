class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https:github.comleg100pug"
  url "https:github.comleg100pugarchiverefstagsv0.3.4.tar.gz"
  sha256 "3979b5f95690f8def808ed49f6e1c7ea9ccce7e7d2f9d194c5ed3e7c8a36ca83"
  license "MPL-2.0"
  head "https:github.comleg100pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aef1dd15a0b44fdc4ef83a87c4ce4506fff7345337c120d56367f5d08d4ed272"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3a50ce94ec7b0aeca3904a2b0eb1b971861466a34e640a8176dea3dfa0430f95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88ef3d35b9943cb87dea3f16139e6bf8870e2f37befe4439bb433d076f526534"
    sha256 cellar: :any_skip_relocation, sonoma:         "d385f45d38cc61a7ae4c221df63b6fdb80afbea6883ef8a607dbc025982a4f69"
    sha256 cellar: :any_skip_relocation, ventura:        "959456e86f79609e3cf59addc9abdc7f192978416dcb7b62a4cbe433d725a17b"
    sha256 cellar: :any_skip_relocation, monterey:       "ae7b995bec012ce0faf9f59ba25b0de6877fd2fc3c11dc6e5ca4bc65fee04ce6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e93cdd0acfce56aec042eb0a8a97439b08b2384b52e40d9bec4911ecf476d928"
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