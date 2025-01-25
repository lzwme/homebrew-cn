class Pmtiles < Formula
  desc "Single-file executable tool for creating, reading and uploading PMTiles archives"
  homepage "https:protomaps.comdocspmtiles"
  url "https:github.comprotomapsgo-pmtilesarchiverefstagsv1.24.0.tar.gz"
  sha256 "b000b392f1b4a7a73ed5b4ac86a91bb1d0f0e87de988f8e156979d2975fa42ae"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af5e5a5ec5b06415b088aa3694a67a4f1c0de7d2268fd3fcd1f1781bd3d1a54f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af5e5a5ec5b06415b088aa3694a67a4f1c0de7d2268fd3fcd1f1781bd3d1a54f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "af5e5a5ec5b06415b088aa3694a67a4f1c0de7d2268fd3fcd1f1781bd3d1a54f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a821134a59133e92e35fd8c85599e29336f69a158329e8596d357303bb8d3b1"
    sha256 cellar: :any_skip_relocation, ventura:       "7a821134a59133e92e35fd8c85599e29336f69a158329e8596d357303bb8d3b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0a11726a011d01d21859e26ae2ed5d27ac2233d6e8d579db09ff7368357b913"
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