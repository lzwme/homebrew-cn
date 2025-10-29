class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghfast.top/https://github.com/onflow/flow-cli/archive/refs/tags/v2.10.1.tar.gz"
  sha256 "ccd47c9d5acfe5f4a4d06e9ef1f6279f7cc6123dc42160de8ac8252805d6ac38"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbbe323862f7cab5fcf6ce2c554e4fe349f0b68d7bfb2985c5b6b22a44acd4bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "695e75b8ff09421e5e4d277965498d67def725cbd743712248da22addd0c5441"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c389cfed2d4ee72fd1303c0fbb86d1881b00f0e2f192ea5a62eb4983db77b1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa742fea28cf8b1c08b1ac2c2c1607019b1423ebfe9a49576f4baed9ea8af84e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9e58c54c6d87f8d3d77dbfad39c6b1a3f5ad73a6769a24fab6a6aa288dae12d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "573d1d7c0852920395081e8b324a4e9d2d9ef6779445b9383de25d9cb2d10d6d"
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