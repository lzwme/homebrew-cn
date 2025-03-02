class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https:github.comcontainerspodman-tui"
  url "https:github.comcontainerspodman-tuiarchiverefstagsv1.4.0.tar.gz"
  sha256 "0b385f11b7cff1143dabe4972c0fe2032a583024660d837658626e9a8e703d2f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef87a332e6a72c1ca5b1f43caa0f0705269890f45872baa4d868fb329cc4c490"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47e7e63b6ee1e9e56344663ed07548520c5f605a9193e254d2edc58c83cb6090"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "346c46f77bb428dc16f23995130d63d79e6ffcd7cd513c118967b6646878f75c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1cca1d019e147496ab051f5cadcd7392251210c914ef75aa1fae707ba3e9f7d"
    sha256 cellar: :any_skip_relocation, ventura:       "7bc8f0830692fb5cc2966058ab9d7636d4245f34a714d0bc654824afa9553876"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9492b9acf0da96632e4986c14abc67a9f9addc208ad74111c11089b53260933"
  end

  depends_on "go" => :build

  def install
    if OS.mac?
      system "make", "binary-darwin"
      bin.install "bindarwinpodman-tui" => "podman-tui"
    else
      system "make", "binary"
      bin.install "binpodman-tui" => "podman-tui"
    end
  end

  test do
    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin"podman-tui") do |r, w, _pid|
      sleep 4
      w.write "\cC"
      begin
        output = r.read
        assert_match "Connection:", output
        assert_match "SYSTEM CONNECTIONS[1]", output
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
    end

    assert_match "podman-tui v#{version}", shell_output("#{bin}podman-tui version")
  end
end