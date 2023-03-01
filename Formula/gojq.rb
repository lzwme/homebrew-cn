class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.11",
      revision: "584107c132bf02d6ab369fb3c8fc8499ac4debc8"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b869a10a784a032b07c6118583163cd072cf46ea5754b5ffdab020b26d34b0cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b869a10a784a032b07c6118583163cd072cf46ea5754b5ffdab020b26d34b0cd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b869a10a784a032b07c6118583163cd072cf46ea5754b5ffdab020b26d34b0cd"
    sha256 cellar: :any_skip_relocation, ventura:        "a68be08e21c44a20939e6a9ef71352a6d3e076abd64d7845ac7320d938e43e17"
    sha256 cellar: :any_skip_relocation, monterey:       "a68be08e21c44a20939e6a9ef71352a6d3e076abd64d7845ac7320d938e43e17"
    sha256 cellar: :any_skip_relocation, big_sur:        "a68be08e21c44a20939e6a9ef71352a6d3e076abd64d7845ac7320d938e43e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b987e025a88356e98d7bafb8e9846024ce22db15b8414e14b71252a7d8096217"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_short_head
    ldflags = %W[
      -s -w
      -X github.com/itchyny/gojq/cli.revision=#{revision}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gojq"
    zsh_completion.install "_gojq"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/gojq .bar", '{"foo":1, "bar":2}')
  end
end