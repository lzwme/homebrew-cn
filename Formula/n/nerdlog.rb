class Nerdlog < Formula
  desc "TUI log viewer with timeline histogram and no central server"
  homepage "https:dmitryfrank.comprojectsnerdlogarticle"
  url "https:github.comdimonomidnerdlogarchiverefstagsv1.7.0.tar.gz"
  sha256 "5e203df042081f103222c7f09fc1aac70f6ef5804c34d7c0fc3794eb3f2b2868"
  license "BSD-2-Clause"
  head "https:github.comdimonomidnerdlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd80b7316656c42b47eea64444d67a23b8819186d1062c5a291a8c116dc87d6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e2f2e14bbb04c3db860902a7e5013d0e4af458249892a9a0dcdd7ebd718d3a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b12fcc9c5892340359ea53f1e1b3967f20032b2359ff880fe015b06fb0e13205"
    sha256 cellar: :any_skip_relocation, sonoma:        "354ef158702f5d972d23fe40cc7c605a9b6f95f58acb7721b11187a147ea312a"
    sha256 cellar: :any_skip_relocation, ventura:       "763e45d4e5d7d878fb53c203382930e2b2b86da8c60c4ca5beddc1a67b98acf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41972a9060652b355390ce90d02370aefac6c9bb743c9d61d8800f2a31b5bfae"
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