class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.273.tar.gz"
  sha256 "f3dac2f1be1b6135ce0464f328e54c6d3dd5556d1bacaeb28c75589f12fd3fd2"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "936360bfe637672637e120794defca96872be5a7f835a87e074a2b764f15ccbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "936360bfe637672637e120794defca96872be5a7f835a87e074a2b764f15ccbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "936360bfe637672637e120794defca96872be5a7f835a87e074a2b764f15ccbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "67eca635740ffc85b911db3e1ad7b29c40f852ddaedb428f18dd3a4087077306"
    sha256 cellar: :any_skip_relocation, ventura:       "67eca635740ffc85b911db3e1ad7b29c40f852ddaedb428f18dd3a4087077306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "284a444c4e901dc9835f23710b42b7fa8754e37d404315cba4ae1c05197e0b1f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/fabric"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fabric-ai --version")

    (testpath/".config/fabric/.env").write("t\n")
    output = pipe_output("#{bin}/fabric-ai --dry-run 2>&1", "", 1)
    assert_match "error loading .env file: unexpected character", output
  end
end