class Dry < Formula
  desc "Terminal application to manage Docker and Docker Swarm"
  homepage "https://moncho.github.io/dry/"
  url "https://ghfast.top/https://github.com/moncho/dry/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "9d556e385ed35a2015dcd5904daa0751c42ee5ec58df71368b1844245551f771"
  license "MIT"
  head "https://github.com/moncho/dry.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5593f64c3c4fae29307b9ab977a8725f6b9e12ae9024b4a9aac2e9ed6f8bd449"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5593f64c3c4fae29307b9ab977a8725f6b9e12ae9024b4a9aac2e9ed6f8bd449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5593f64c3c4fae29307b9ab977a8725f6b9e12ae9024b4a9aac2e9ed6f8bd449"
    sha256 cellar: :any_skip_relocation, sonoma:        "47bb1914eba8c2a6edf6e49e2fc05b43f5a16607db1430db5974dd1241a1a06a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d7b33d236dca51a679399147069b6a4b15405a43e302d8cc9ab0ab8b29353ab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "462c31d953860e02577cd9cfb51d9ce321e58081f9c7f26ac7eacfb839e2075b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/moncho/dry/version.VERSION=#{version}
      -X github.com/moncho/dry/version.GITCOMMIT=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dry --version")
    assert_match "A tool to interact with a Docker Daemon from the terminal", shell_output("#{bin}/dry --description")
  end
end