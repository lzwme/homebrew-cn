class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghproxy.com/https://github.com/onflow/flow-cli/archive/v1.4.2.tar.gz"
  sha256 "9c9b82bc08914a566b6cef69f8884dfaafabc347410faffc054cf97123e3b2bd"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae8b1688b35d080c78a1b5b7dcbbdc4bc80dc48ae3a4619399e11f231a96351a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30c2b8e6f3939caca765282614aaffd0e5bbd9dec6de6f2bea3586d0b5977fe9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6d1f7789910ffb1f8ccbefb49f00d61ad0b8ff6927a40e8c664e8e173acec1e"
    sha256 cellar: :any_skip_relocation, ventura:        "2bbcb6ff1a0792334081109d5f24c3bf19ef6bd3088dab51e286b194db0ad2a6"
    sha256 cellar: :any_skip_relocation, monterey:       "6b52aa2a221b7060aa07ee1133e817cd565e3aef7ec48f3ec62f2fe216247e15"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7b84ae13d88aa955aaff126eb07b3cf4b837fed206e171043e9298125194c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6b5450bd864d0585953db7d948f53931903d30e9ca1c93b73c31e07ab55e6ac"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end