class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.26.0.tar.gz"
  sha256 "ea48f193c6da3bf809a549561ca95b73cc02c832ca450c352110d1ba0defe42b"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a38fb05d15c33e0faeea1df2adc39cbdbc4f63ff55572785afd8bf5bff74c9c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a38fb05d15c33e0faeea1df2adc39cbdbc4f63ff55572785afd8bf5bff74c9c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a38fb05d15c33e0faeea1df2adc39cbdbc4f63ff55572785afd8bf5bff74c9c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d307346c1d09f518dd487fe2b0aa8b3a765917b0afdf90754a04c3bb5eec317"
    sha256 cellar: :any_skip_relocation, ventura:       "4d307346c1d09f518dd487fe2b0aa8b3a765917b0afdf90754a04c3bb5eec317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b156608d805ea70f8d2a3604a58a071aa0a157b5bfd81c6dd3a7f1445457cf69"
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