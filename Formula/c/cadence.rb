class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://ghproxy.com/https://github.com/onflow/cadence/archive/refs/tags/v0.42.5.tar.gz"
  sha256 "0c14cc7244609b431b0a281baf1eb456dac11b48bd0c2e52543e6154e0420103"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "728121d85cd973f7f8b4a49f43b44c183a73782e7bffb69c80f3bca228e8b5ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e115cdf6abe816b1664b1b0b71c267084b0c2c2a5d767c5bed1a38052b38340"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9f2d43383e3667efe07bc2bef7e0e8c9799c241c5aeb52668fce0a1a16d4b90"
    sha256 cellar: :any_skip_relocation, sonoma:         "e97f35a46853629d38f27421f975af4b9eb83a045d58e9dabede95b94d51b433"
    sha256 cellar: :any_skip_relocation, ventura:        "fbdbf1ab33ca56313f37dceecd6442df01262d2c190028be340b6c19383ee7e8"
    sha256 cellar: :any_skip_relocation, monterey:       "1bf61044727562d04ce55b229b824318c9cadfff4eabfb73bdd9ac4ef0c75b8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbfb118ec7f1db24754b1ac1dc7f437ac375157ff31cce8689f9e467f159b6d2"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end