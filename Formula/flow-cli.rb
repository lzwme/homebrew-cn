class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghproxy.com/https://github.com/onflow/flow-cli/archive/v0.47.0.tar.gz"
  sha256 "fbabb126d8e2c7504865a70964e530c4f234fe302030b3c51759111f58f2f494"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa0aca1bd743eb2a0acfee7f3958968b385d3bd01a6d8d5989db46f6a83baa3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe86c068d19444f73e7c91181033966101b7a9332529e0643cdcc1b8e8db2596"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1d8925f045b4649fc16f1e2641f8c4e694e0aaae0d79b99a6fa9bfe38a242d7"
    sha256 cellar: :any_skip_relocation, ventura:        "926d27aa9b941d4628266bae9b0a5dc7e352436a8ac3a3be73b11d7a7443f421"
    sha256 cellar: :any_skip_relocation, monterey:       "5638220f22475e25f2c659ff9cc8f1ff1f67b70a6e283c1ee0e31a21bc834de5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f5bdd8c0c897c2347f36e84ed7689f97d1c2792f366f27a5ff1203922701b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6847b86148278f34bbf6090bb7a18fbb1f627f23d14668a4bb51457bf602a7c0"
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