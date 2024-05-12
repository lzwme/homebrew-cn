class PodmanTui < Formula
  desc "Podman Terminal User Interface"
  homepage "https:github.comcontainerspodman-tui"
  url "https:github.comcontainerspodman-tuiarchiverefstagsv1.0.1.tar.gz"
  sha256 "c7082506573c797c26acf4dba033b717330a2caafa451ec3175966f5d4342aab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41a98af35319d4b7737e7e398a83b8a75be3e05a99d9539f000a75325773e3c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9c4ba8175433de07e6b0e52ee3cf1f4d260919a6fec589e94b6182ef529537f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28be1e4f51a6aa0c85dad34bb2305509c1e8ebb626478889fc1abb6eea6c1f5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcb006bfd0bce5546ddf308e1589489320d5f70be3be1fcf6a213b20253dcba3"
    sha256 cellar: :any_skip_relocation, ventura:        "76add6de18ef1559c7696cc7c9427141d2389a2bab26dd95169c4fb5c52a0f97"
    sha256 cellar: :any_skip_relocation, monterey:       "4fd060dde9cc21e8b86bfbf9a673e444fb16b4bab2c2764fe194b71961425c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1549f2c097ed943a06ac404e368c08e32bf441a923fecf0425898ce3a7543a4"
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
      sleep 1
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