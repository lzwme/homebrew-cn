class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https:github.comleg100pug"
  url "https:github.comleg100pugarchiverefstagsv0.4.0.tar.gz"
  sha256 "a6f446e77fccb05b0478f5cb4802ef37fb70c680adf9932e8b4bd7b053f99910"
  license "MPL-2.0"
  head "https:github.comleg100pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d82dc825ff6fe4414b7f7a79351388f18a873b8aba8b4412237d1f988e54dd73"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf1cb42fab37b32bba436ad173fb84e1bf9d51371f524864ae08974680f24d92"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb5e00b7ed3f62931d1e6ff52151a86cf9ac64adf2bc72d46f311aa81c3259b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "046a0d302f8896d4cb2a530fa7af42419fdc76dd8713039b047f9d62fe38ffd9"
    sha256 cellar: :any_skip_relocation, ventura:        "350e7c19b31d8d4a8df95fe67fdd3bd022735eca403eecf7fbe2ef4ccdf62be1"
    sha256 cellar: :any_skip_relocation, monterey:       "a6e7620fef6a91e2abf46b064be973964445d278403c044e744bda1e8390ae8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "209a18c841a706d3b137e2ed9bfbd515ef411df4c423fd2d52e288f0b0dac369"
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