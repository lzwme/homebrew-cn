class Oj < Formula
  desc "JSON parser and visualization tool"
  homepage "https://github.com/ohler55/ojg"
  url "https://ghfast.top/https://github.com/ohler55/ojg/archive/refs/tags/v1.28.8.tar.gz"
  sha256 "c14476b4d7b9a71a28e74c7c3b7b09b4a3be472de88d055de412f5744ee55d29"
  license "MIT"
  head "https://github.com/ohler55/ojg.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "301658560bcd95d8d4cff304e3de80b371a344fae0968296dca6ce6c52f55bbf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "301658560bcd95d8d4cff304e3de80b371a344fae0968296dca6ce6c52f55bbf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "301658560bcd95d8d4cff304e3de80b371a344fae0968296dca6ce6c52f55bbf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "06fe1dbcca6ee5d57e79bed9024b1983d532e40d91e97a3194cfb11e0823f843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "76ee74e1c273d3a5c7f675f9ea5a3f45cff01c1644f95f72ceafb90151574489"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=v#{version}"), "./cmd/oj"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/oj -z @.x", "{x:1,y:2}")
  end
end