class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.25.1.tar.gz"
  sha256 "9345dc4f0d9c9f5f63b0d952e62b89100bfcf1957daa2044c53688f61638bff7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5385160f4cc28dd602702e7d8585e0a385de54b3c8adea1d9039c3aa75ac4b05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5385160f4cc28dd602702e7d8585e0a385de54b3c8adea1d9039c3aa75ac4b05"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5385160f4cc28dd602702e7d8585e0a385de54b3c8adea1d9039c3aa75ac4b05"
    sha256 cellar: :any_skip_relocation, sonoma:        "a887699bd63838a6e41ae68b3d3fc6f0a747ba3f0879c23c96a4bc82d4b922e6"
    sha256 cellar: :any_skip_relocation, ventura:       "a887699bd63838a6e41ae68b3d3fc6f0a747ba3f0879c23c96a4bc82d4b922e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2bb47a23fd0e7c6536bcd9074fd32b6808b48b3220fd329f701880e45c5dd7f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port

    pid = fork do
      exec bin"pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http:localhost:#{port}")
    assert_match "HTTP1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end