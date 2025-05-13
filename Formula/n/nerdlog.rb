class Nerdlog < Formula
  desc "TUI log viewer with timeline histogram and no central server"
  homepage "https:dmitryfrank.comprojectsnerdlogarticle"
  url "https:github.comdimonomidnerdlogarchiverefstagsv1.7.1.tar.gz"
  sha256 "5ad19051b84f2b1dcd569327fb768ea50f622351e223b4bf72f2ecb36b32f0b8"
  license "BSD-2-Clause"
  head "https:github.comdimonomidnerdlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "573c041950d6666fdbe164d6fd775b7d45a6e9cd62922c23521449a01fe07a88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "197be649d3d3103a204af055b52346b403c96cb66adbaac5ca118180d9cb4cd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "350d578e61d70d51c59c4012d97a82b5b7fb3c92a32c5273ebbcb77d848ff44d"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d7e91d30a4dfef524e8b703c58b27c637a1627898ced0a99ea3a17c09db2fc8"
    sha256 cellar: :any_skip_relocation, ventura:       "27877961be3bf724930ee5e290784c51cbb44b0c91b15e15aefdce7b96e8b061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e189208aa1f427679f57fb768e22094b70d7ae9f1ae92507242299688f61fb09"
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