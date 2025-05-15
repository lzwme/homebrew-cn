class Nerdlog < Formula
  desc "TUI log viewer with timeline histogram and no central server"
  homepage "https:dmitryfrank.comprojectsnerdlogarticle"
  url "https:github.comdimonomidnerdlogarchiverefstagsv1.7.2.tar.gz"
  sha256 "58e14206c74d4a1f0d85a3cb08ae8b4c60c9d37adaf7fdf0b63ee53c9d8b3bd8"
  license "BSD-2-Clause"
  head "https:github.comdimonomidnerdlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "352bacc589c1cafbea8e2989fabc306792598fed3549de85612ec84d7e1e7fa8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fe02e39a138bea3795bfdf1a5939312f8d50ae92ec00f073cdf558b32e7e9b8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4b5ab4f1f7142a0227dde5942fabae1d25478027f4baaf4e62fc12c3fb221812"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dd4af014d0f1c82a8e5f251d31d47f371196e815cba34ca2a06bb11be1aac83"
    sha256 cellar: :any_skip_relocation, ventura:       "f314a695461cd74a28ff16fce9b6b8527ed6e323c1a0a434bea8ae794bb4bfe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "81441f01e45aebc9e89d16a110f34dd019a5cb1cf4183d80eca52f4a727defc6"
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