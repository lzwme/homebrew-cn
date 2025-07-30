class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "23c36f5051c4acf90ff2d0f2e33945e267c76e2c4618fa9ee9a44c1779eaf4d7"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5039c541168f2e8150872b9416192acaabc5a2b12b1bdff40534b434f59c3433"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1b27ae8ea92968b11f27c1665a73efd4c5235709a550e3593189b80d042ef8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10c12a197e4b29b6e50d490a65dd09441cea138d9e0b1509c3f34ee5f5d35a40"
    sha256 cellar: :any_skip_relocation, sonoma:        "59d0a128e3276921476b7668c3b40d32320d34992158ea54600e380674fbd1f9"
    sha256 cellar: :any_skip_relocation, ventura:       "324d19a39e3ced4b12b1afe9505e5b5f7d7ca8a884ed88269e5a1d6add4e7971"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c3e7c5147290fdc1e93fc3446aaf944963247ea78a877f1c5788b2f14c0bd243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "989c067883971484bfaeeffc429d2705604e63ed731d38a134684c82a842635e"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end