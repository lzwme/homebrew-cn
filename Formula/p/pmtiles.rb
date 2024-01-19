class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.13.0.tar.gz"
  sha256 "58f0ac8acb03157c1d9d6b39791af0790821dee91580a00f0fa5c07e84677df0"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9937895ac4c6a83af53b2392e9873c639016431bf0f6db6a28559facc54e7a9c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07f7d3f6bf21065841c7ba7ee9788bcc55c51203a8f3afdc8533e964462e910c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b9deb9622749a2c342970936d1901aa12a8dbdb9eef585229da9c562e528b2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "65663d7a60bfc36bab92d0606c9b3f5d67b69e68cae2ac95fed0a3efb958c9be"
    sha256 cellar: :any_skip_relocation, ventura:        "4a80c7ff509f4fddd4aba7c054366bb4f6dc0fe9bf8a52e11a8c54f51cb0b82a"
    sha256 cellar: :any_skip_relocation, monterey:       "5029d319ff0c2a7c089563c7eecdf39b2d64787ff849d708a3ef1a4537f4dab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0896555075abb3faca4903acbb172de77ba4cbfee6871b520a4b8357a1ffcb94"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}pmtiles", "serve", ".", "--port", port.to_s
    end
    sleep 3
    output = shell_output("curl -sI http:localhost:#{port}")
    assert_match "HTTP1.1 204 No Content", output
  ensure
    Process.kill("HUP", pid)
  end
end