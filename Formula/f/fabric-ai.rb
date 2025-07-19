class FabricAi < Formula
  desc "Open-source framework for augmenting humans using AI"
  homepage "https://danielmiessler.com/p/fabric-origin-story"
  url "https://ghfast.top/https://github.com/danielmiessler/fabric/archive/refs/tags/v1.4.260.tar.gz"
  sha256 "2e31aa5f511fee7f1584cd016d4e2abfb8998760cecd2466a2901a16fffbda30"
  license "MIT"
  head "https://github.com/danielmiessler/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "400244944f756639a44154221dee91db2927fde566349411f459a586f120a8a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "400244944f756639a44154221dee91db2927fde566349411f459a586f120a8a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "400244944f756639a44154221dee91db2927fde566349411f459a586f120a8a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "03e2ae1d378654f43d209d75848aa96184ae9149072105e3089a4850cde1a4c5"
    sha256 cellar: :any_skip_relocation, ventura:       "03e2ae1d378654f43d209d75848aa96184ae9149072105e3089a4850cde1a4c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38a0aa0496a7471efbb82c65da902986baacf6d4cf554f891c82f2c49579c87d"
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