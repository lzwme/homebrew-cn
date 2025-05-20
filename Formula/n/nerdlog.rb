class Nerdlog < Formula
  desc "TUI log viewer with timeline histogram and no central server"
  homepage "https:dmitryfrank.comprojectsnerdlogarticle"
  url "https:github.comdimonomidnerdlogarchiverefstagsv1.8.0.tar.gz"
  sha256 "90b2a5f09f24a6429eeecaa3e2ffa62b20562390b0151176caba36061347ebf3"
  license "BSD-2-Clause"
  head "https:github.comdimonomidnerdlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "beda3e74265ef3511630b472b64b04094d7a6ec760cf9eb97b72919113e5e44c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13bbb19659313571b09e3fce75d1d1f1dd3a77764e03d6da3e16e0f65290d2da"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50a863f27cf6e8ccb157d20dc981f832d2110fc50e9e41917ba1d260eb19bd1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce1f85a610d8634e3de21beaae50183ebfa46a58d2d51a8b2bbdb5d17aec9cda"
    sha256 cellar: :any_skip_relocation, ventura:       "7ee0c1256749e351d0170c8e8d4214e3ae790be0fc05670c2dca9f18c0c40a39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "accc9e0ca04663464086da20422e2a814f2f1784c65fac5c60f5ffdc80177e63"
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