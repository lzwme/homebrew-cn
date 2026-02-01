class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://ghfast.top/https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "bbc038b1d2b75d5a6ee089f43070cc2bab2147ff4071ffe7c586179521fb57f7"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2a190ab3396ae080c2b384a3fda45fe07ef1da691e603bf561f2fc8c560e41fa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a190ab3396ae080c2b384a3fda45fe07ef1da691e603bf561f2fc8c560e41fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a190ab3396ae080c2b384a3fda45fe07ef1da691e603bf561f2fc8c560e41fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9f175ae7521fd777351efd223eee865ed2c370cc436437b95335a3400c14481"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b922df6493da0c1deaa2779502cb7ee27eb2adaa7cea17b31ed5f9f9d0599c7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e4b76c0fd5cc1dcc509bac2e72cca076f5befe43545ede00063ce606f7d5ad5"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, tags: "release"), "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end