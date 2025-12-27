class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/2.13.2.tar.gz"
  sha256 "2906c00f8c10867bcdc2fff8e153a3f08be3d394c24dd9c91ed97bc95e983b5f"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f635cc9ba9bc22147d4d06bb80f4522a57946e3db14720436c20ed28bb06cf50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d70a64d66129de6134d371931e46267c3dafff12595eb1d42a1602213bc0b08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "993fe71a2ed3449f35f2fb4cf9dc4b20072ee012fd5368a1d1d34fdd05c36e35"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e124b120e12160b0a578fd9eadf331402d59ddea4cc2dfb6904ad55bc9e55d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68df28a8599aa81a1b7d68d8d08a0752d11eea3863ba5078168ac9319226f4a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd17ef61ca2744ca214e348fe80ef66c69e5bb09acf1e0e79ad34442ab8c2e1d"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  # bump cockroachdb/swiss for Go 1.26 support, upstream pr ref, https://github.com/onflow/flow-cli/pull/2239
  patch do
    url "https://github.com/onflow/flow-cli/commit/bec1ee457616b9e39552bc15dc1d0370472445d5.patch?full_index=1"
    sha256 "95c667fd71df39479f3368d5400351d47c3a870592497daba484f38efa88d446"
  end

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", shell_parameter_format: :cobra)
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