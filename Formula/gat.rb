class Gat < Formula
  desc "Cat alternative written in Go"
  homepage "https://github.com/koki-develop/gat"
  url "https://ghproxy.com/https://github.com/koki-develop/gat/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "1a6ed43deddb46766cc81c85485d2aa10dda802a7ded58e9c9d8241dd503c219"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2f9dcfa8948db1a1608ce642801f008542cd58709c9dc6ec7db92920efb9d30"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2f9dcfa8948db1a1608ce642801f008542cd58709c9dc6ec7db92920efb9d30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2f9dcfa8948db1a1608ce642801f008542cd58709c9dc6ec7db92920efb9d30"
    sha256 cellar: :any_skip_relocation, ventura:        "dd65c6653dc3be129d858f7530112d37552543b6011de23a443b09c9d5cdf8e5"
    sha256 cellar: :any_skip_relocation, monterey:       "dd65c6653dc3be129d858f7530112d37552543b6011de23a443b09c9d5cdf8e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd65c6653dc3be129d858f7530112d37552543b6011de23a443b09c9d5cdf8e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f26173eded300945909cfa430c2ec34602ee69f19d64da9809958a2109fa382"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/koki-develop/gat/cmd.version=v#{version}")
  end

  test do
    (testpath/"test.sh").write 'echo "hello gat"'

    assert_equal \
      "\e[38;5;231mecho\e[0m\e[38;5;231m \e[0m\e[38;5;186m\"hello gat\"\e[0m",
      shell_output("#{bin}/gat --force-color test.sh")
    assert_match version.to_s, shell_output("#{bin}/gat --version")
  end
end