class Nerdlog < Formula
  desc "TUI log viewer with timeline histogram and no central server"
  homepage "https:dmitryfrank.comprojectsnerdlogarticle"
  url "https:github.comdimonomidnerdlogarchiverefstagsv1.8.1.tar.gz"
  sha256 "3cc38db15e57e8106f1d2da571136b0ea4dab74a351f577a3ce8d63a16900fa1"
  license "BSD-2-Clause"
  head "https:github.comdimonomidnerdlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "19ce16332ba95b53dff502a55254fdc1b8597fe9c5b02a0b448998facb81a046"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "337c1837add4345d9c457973e5f26407d8e31eadda0e459db693f2214ba25bd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f04ede4740804afd7b9415d4725603de3719725c5c1148193c351daa0e1d1398"
    sha256 cellar: :any_skip_relocation, sonoma:        "630d6b2df2ccb39f9d15eea9dbc2504d93e776c70a40c92f87ca9bc29b56c1eb"
    sha256 cellar: :any_skip_relocation, ventura:       "6300d792dce668f5ce0bc3b650c4bca92fe2c86933e728a1184c94d527e9456b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd2e107f598b62223a713d32c3de80a4fdc8e31d139e88f13db5642d319078b5"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.comdimonomidnerdlogversion.version=#{version}
      -X github.comdimonomidnerdlogversion.commit=Homebrew
      -X github.comdimonomidnerdlogversion.date=#{time.iso8601}
      -X github.comdimonomidnerdlogversion.builtBy=Homebrew
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdnerdlog"
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin"nerdlog") do |r, _w, pid|
      sleep 2
      Process.kill("TERM", pid)
      begin
        output = r.read
        assert_match "Edit query params", output
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end

    assert_match version.to_s, shell_output("#{bin}nerdlog --version")
  end
end