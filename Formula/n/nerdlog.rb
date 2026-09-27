class Nerdlog < Formula
  desc "TUI log viewer with timeline histogram and no central server"
  homepage "https://dmitryfrank.com/projects/nerdlog/article"
  url "https://ghfast.top/https://github.com/dimonomid/nerdlog/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "67cb9bcac2ae8c5fdd0b43232b1ef48c9d3966ba6b1b246fddd3154b31aa1f86"
  license "BSD-2-Clause"
  head "https://github.com/dimonomid/nerdlog.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6a1c08a7cf950cb89fbf4b105e9fb555e8b07ee47873aad7fdf5af6d4ee6124c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cf496769765407c51a3d61d6cd3457572f715ff512399643476ea2e5d0896f43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "22fdad6974c076a75ed4a126d36a40adefa00061f5b5513b07cd7048dd06031b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bc828668171f7cf4a5197c19fc77b151a35c84db0980ef00c382787c41f7eca3"
    sha256 cellar: :any,                 x86_64_linux:      "d64f24a1eba5443c9922d2a540d3ba764fbdb9c6632cb851f21a21b38b8b4f63"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "libx11"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/dimonomid/nerdlog/version.version=#{version}
      -X github.com/dimonomid/nerdlog/version.commit=#{tap.user}
      -X github.com/dimonomid/nerdlog/version.date=#{time.iso8601}
      -X github.com/dimonomid/nerdlog/version.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/nerdlog"
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"nerdlog") do |r, _w, pid|
      sleep 2
      Process.kill("TERM", pid)
      begin
        output = r.read
        assert_match "Edit query params", output
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    assert_match version.to_s, shell_output("#{bin}/nerdlog --version")
  end
end