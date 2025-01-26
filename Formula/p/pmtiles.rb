class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.24.1.tar.gz"
  sha256 "65509b5fa1544d125a89b6a8f48042f90ed82488c19b01721cce7b76b581753c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77f9cc28a28109a6b7bd615c795b63d9bab192a192b6adc184381672f3051bcc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77f9cc28a28109a6b7bd615c795b63d9bab192a192b6adc184381672f3051bcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "77f9cc28a28109a6b7bd615c795b63d9bab192a192b6adc184381672f3051bcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d01cccbf12fdcb1dad2f68be1571b1151b6abdd60414518f0e02ccfa7c7f4b7"
    sha256 cellar: :any_skip_relocation, ventura:       "0d01cccbf12fdcb1dad2f68be1571b1151b6abdd60414518f0e02ccfa7c7f4b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3555dca71b58d0516c71302a4236d585401d99df9ffd4139f58c242a6ed2bba6"
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