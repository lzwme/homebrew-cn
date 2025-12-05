class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https://protomaps.com/docs/pmtiles"
  url "https://ghfast.top/https://github.com/protomaps/go-pmtiles/archive/refs/tags/v1.28.3.tar.gz"
  sha256 "9e45ed5cb97cd6c7bcc0dc515679ab4211240024ae61ba011d76414fd0ca0b6d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95f6b2cf7e028da9fc63fea69a29a175083f6d246613d254e023144f758f4034"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95f6b2cf7e028da9fc63fea69a29a175083f6d246613d254e023144f758f4034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95f6b2cf7e028da9fc63fea69a29a175083f6d246613d254e023144f758f4034"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2546aa859e9cec52d2e642b7c6a004119170235274a9715fc1a4deb6b7faff9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d072c9fd0fd1320d28d6aa53d66d241074c753fe669abd0d75b21f3c368bb38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e2ff16cfcea15137efad1972971a8608235c3a736c14b83934a499fa58925bd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port

    pid = fork do
      exec bin/"pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http://localhost:#{port}")
    assert_match "HTTP/1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end