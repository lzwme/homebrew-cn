class Nerdlog < Formula
  desc "TUI log viewer with timeline histogram and no central server"
  homepage "https:dmitryfrank.comprojectsnerdlogarticle"
  url "https:github.comdimonomidnerdlogarchiverefstagsv1.8.2.tar.gz"
  sha256 "e448a9150a5cb186f1c448a886666e5b5f5001c77e911e839a2294043289b7b6"
  license "BSD-2-Clause"
  head "https:github.comdimonomidnerdlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "644197db8c207db5d49dffe2a6fe366f0a3c563470747ef37c3098e0d7fce6ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efe6bdc31cd22c25c9edbfb09df45c37b567398bd6fc8dc685f2410177b395da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "51149f6d203c2a20c0f66a99b1ba0953288c303600bdcb2ed66a08c3c239c575"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5d46e21d3c932a952d3a602cf9bf6a561e68ad3b4af17d6b800506051f3f623"
    sha256 cellar: :any_skip_relocation, ventura:       "1d7b32ad8628d2f9b6df0fad97737ddfa6542511ef45cafba9ff91eb0a894943"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86231eae6c2356e27fc31af809ca83f5a7af5b3f0e365b0b24c0c6d244ff59be"
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