class Pug < Formula
  desc "Drive terraform at terminal velocity"
  homepage "https:github.comleg100pug"
  url "https:github.comleg100pugarchiverefstagsv0.5.2.tar.gz"
  sha256 "e2992860bbb47b20359435a7a3676d4a99929744efac9551b2b472dd5f9b8cc2"
  license "MPL-2.0"
  head "https:github.comleg100pug.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d156ed70060f4de355e31d72a0f04ebb00f50d17323098d035cf2dfe46a2363f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d156ed70060f4de355e31d72a0f04ebb00f50d17323098d035cf2dfe46a2363f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d156ed70060f4de355e31d72a0f04ebb00f50d17323098d035cf2dfe46a2363f"
    sha256 cellar: :any_skip_relocation, sonoma:        "2724b0d63b9cb84d7961224009952ee92c56626666b20f48222a1cb318d0115d"
    sha256 cellar: :any_skip_relocation, ventura:       "2724b0d63b9cb84d7961224009952ee92c56626666b20f48222a1cb318d0115d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a33377c4c450328c492d548b055d805a3ad68f52a1da9bc16e3ee112a0de548"
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