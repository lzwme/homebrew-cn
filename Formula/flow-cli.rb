class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghproxy.com/https://github.com/onflow/flow-cli/archive/v1.3.0.tar.gz"
  sha256 "e919221ddd7709335c5c87143bdecc22c7ecaa1fc7200cb7e2766ed28669dcbf"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00cb82cdd03d13d90ba6415ee4ae171759dc64d2efac7a4dab8563fbe9ec43db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c78c792ea86f066bdb72758cb5d51a1f84affac93fa14eba41ce0b4c91ab7b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "334f725d36a1b75752640fcadbd391a8946c6b20ba4809a3635c9cdc410387d0"
    sha256 cellar: :any_skip_relocation, ventura:        "7a6aa84520fe48d86b8f65a48e9a0b9273b92f0d3deb46529a584f95ce0ecc23"
    sha256 cellar: :any_skip_relocation, monterey:       "1a6f2af35af5a8f1e348509e315c316b05c6f143f47aab5bb6cbdda5d0378c2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd79d1f492b661f7c5154da3065c9a79b6db4aaeb496c76e6310b8e96b353c57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96e7f3c736f3d9e5c5aa2ae8462682d0f2f1bcc8c44267a15caf57bd8003d070"
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