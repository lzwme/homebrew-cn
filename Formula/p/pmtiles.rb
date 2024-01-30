class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.14.0.tar.gz"
  sha256 "2a0ede62d804a90c6cb608fca3f831df6fe3abf55439a1f0cca8be8ee5d17502"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "54d0c5cd754c2cf7ed56f237cc3a02939ba54f802db729c9f494690536fc2d16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "512fb4ed77791209a78041c364357b0fc4197d0cc48555be76ad044255940235"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5eb24a95f710a28c85206a62e7a5fd00a4c4a57a596260dd615d17f26e9c0f0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f8a05cbbdcc45056850ac3bc25151b4d3e763611d157c54478468385b17e9259"
    sha256 cellar: :any_skip_relocation, ventura:        "55d9e014ff959ca01840c0ff0f18ce41d16988d8efea12c5e630cd3ae305c06e"
    sha256 cellar: :any_skip_relocation, monterey:       "66855bc9b6a2d78c1956f8f17908189656c2ebbd5e7d5157d6816041759203aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9154cc62cb36ba5374ebdda63065af925f281f15a71865608598a24ba4f7e614"
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