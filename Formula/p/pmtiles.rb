class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.22.1.tar.gz"
  sha256 "f94ef5867c45958724227254a2c6d0b4e561a1de102a97c82000f07e0fd4483d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fa56b78e0013ff1c9616fae3ed9e7d3a6aefd6d6567bbc83c7c303e9c5c9f0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4fa56b78e0013ff1c9616fae3ed9e7d3a6aefd6d6567bbc83c7c303e9c5c9f0c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4fa56b78e0013ff1c9616fae3ed9e7d3a6aefd6d6567bbc83c7c303e9c5c9f0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fd9423f07ec0ba44a17c7ecdb143110bf00172bfdaee505b3a1ea8cef91ad10"
    sha256 cellar: :any_skip_relocation, ventura:       "1fd9423f07ec0ba44a17c7ecdb143110bf00172bfdaee505b3a1ea8cef91ad10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22dbad70fea86537f1f62102796893df95ddb05ed003e3facfb1ba74ebc1b92f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
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