class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "9a34d0355b663c8c2e15a8d4b090f9108b106dd77b6bb89fc897f10224b9d39e"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "551e8c5ac15845c69d359bcd47ca03b3a59bf8c9fe04eb04d6d51402fe090e42"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd99eeaa06aa9aa5e3b12230ad4acb9e8342bf8db40ee5786ff66817e7db55f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55de68b81d0b3e4fcc566282d8731a008d8813a7a9c3a5f08e5d4436bd686446"
    sha256 cellar: :any_skip_relocation, sonoma:        "e404589b43f0df40fb4d02d57c8fe2a93ac225246179cf42dbf6b1def05da277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03b8f28112bc4b7f346772e0b54e3465c344bdc0c11d9d51b788363a84c6aefc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3bbb681d8a7e30c51b1937606495c388804d37a17cb67877dfdd23cacb132f8b"
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