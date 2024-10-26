class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https:onflow.org"
  url "https:github.comonflowflow-cliarchiverefstagsv2.0.9.tar.gz"
  sha256 "ee4589dbee30109324c9bbd3c1c89fec65c0633614fb49e7931e88b856d6c016"
  license "Apache-2.0"
  head "https:github.comonflowflow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "028ade3c3a65b6993d3c6643771bf55d502e2dacc3c78b75a65ce2b396bed209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "506ffdd4f836ffb27de460e6f5219a0f8e9930bda27c45b7a9bc864a9109e546"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6be627cfd40c94ac923c413df0ee53e6bc704bc1633e22104a5496ae314f5d86"
    sha256 cellar: :any_skip_relocation, sonoma:        "d82129151eb84c0501332b7f6fb798d3785fd029aec882b8de3073b79c33691b"
    sha256 cellar: :any_skip_relocation, ventura:       "dc27b28af9ebb961f5ca788b45e0c8c30926e2c5fe5e313e573d0fea98606b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db6b0e97794e5083a46dae94211188518f74935040d0610823025519f322ee9c"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmdflowflow", "VERSION=v#{version}"
    bin.install "cmdflowflow"

    generate_completions_from_executable(bin"flow", "completion", base_name: "flow")
  end

  test do
    (testpath"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin"flow", "cadence", "hello.cdc"
  end
end