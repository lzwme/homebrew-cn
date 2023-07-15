class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://ghproxy.com/https://github.com/tsenart/vegeta/archive/v12.9.0.tar.gz"
  sha256 "26e8a072ca89b7ee059fb7ac87122374c316acbeabe66dce31a48d401922bbf7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53757d193a21f5d9deb2f68c0b0836c4e5e8522a73da8c14f99c33ae55ad04bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53757d193a21f5d9deb2f68c0b0836c4e5e8522a73da8c14f99c33ae55ad04bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53757d193a21f5d9deb2f68c0b0836c4e5e8522a73da8c14f99c33ae55ad04bc"
    sha256 cellar: :any_skip_relocation, ventura:        "005c5b34550afe8433fc4a2805c5f5d385ab9bd789b0f6446eee30a0d82df023"
    sha256 cellar: :any_skip_relocation, monterey:       "005c5b34550afe8433fc4a2805c5f5d385ab9bd789b0f6446eee30a0d82df023"
    sha256 cellar: :any_skip_relocation, big_sur:        "005c5b34550afe8433fc4a2805c5f5d385ab9bd789b0f6446eee30a0d82df023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6ab1ef42507aaa729615beee0c837bcaa9a4076fd0875ebf1d407597776bcb7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Date=#{time.iso8601}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    input = "GET https://google.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match(/Success +\[ratio\] +100.00%/, report)
  end
end