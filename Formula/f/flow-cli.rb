class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghproxy.com/https://github.com/onflow/flow-cli/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "404ee56bce858ae3f1656513e85105186d80a1dd8f8094bc41e40635c58fde0d"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a06763d502731ac1530485e118b2c90600f6ba1374344eff3a824c35c65c195"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccde7f65fca79de55fb12491c29aca995b815b16c1c15983c75d45424c9a2e7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e7a8ab3a10752fd7c517fbe4003e511bff76d679e7804cb9e065ae013564cd1"
    sha256 cellar: :any_skip_relocation, sonoma:         "63e6647e48320ed4e43a5f8489ab7f1d7a4170f40bcd01202c4774b462c49993"
    sha256 cellar: :any_skip_relocation, ventura:        "845ca132a260ddc1891cfc0c4c095c2e7bc8e9e107afc765271bdd5b59699d16"
    sha256 cellar: :any_skip_relocation, monterey:       "52f7af7989ecd66fac172f90b54d348c871bb75f19aa8e7254d3c7ef41c372ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab3d4d9087ae6e8004c5c64019ada1335051cedf595c1222fc6a5062c2a0750d"
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