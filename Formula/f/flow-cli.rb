class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghproxy.com/https://github.com/onflow/flow-cli/archive/v1.4.3.tar.gz"
  sha256 "8119266b183faaa7da80444d8fb8f8f8e22c938a7fbb1ad97708390cd55e6d9e"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a72d2b34ed951c7c720b9f024ecc0c9d7086be13314fac459c931372081a1226"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "48dc9380de0976714ba8123e7cc5af978af100c142e850e3f70f28900e4f1fe2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c31a12bac20840e2a285ecc9e00bcfa9cfc98d00bc464ec970a745253c02d914"
    sha256 cellar: :any_skip_relocation, ventura:        "abe6ea9d2e435954bfac87c465184b668f41bde165bf09434d23dde6b628a89b"
    sha256 cellar: :any_skip_relocation, monterey:       "1c43a8b51194a4bd6251ba3d3ac00b4af4b9b4928286d294dc794da741285980"
    sha256 cellar: :any_skip_relocation, big_sur:        "eda0d5eea7de94694d36de73e6672204fddf623e34e6ab563f136095fa3da1d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4503c9a5f9178c527938bc772548b5af1a4d881df459e6de5d9508218b79f8ab"
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