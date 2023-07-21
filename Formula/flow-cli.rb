class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://ghproxy.com/https://github.com/onflow/flow-cli/archive/v1.3.3.tar.gz"
  sha256 "6730c3222a55f2cccb0ff3bfb97ec6a377668ce9cffa7192833a59582ea6a429"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cb31b23db731d3f1395682efc6e052b04878d21d1f6955f134135e23526de73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01a87beb7a2d5307a64396c1a0e06b52fdddd1a96cce44f21e0b1003fafc2029"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cbac7ca71cb7d419b2e11245ce674f05955b2f082ba523467043da8e2582e36"
    sha256 cellar: :any_skip_relocation, ventura:        "3b6a47fbdda8c95a00c056f78194bd20979e5604f00bc15809e26b0bceb64c24"
    sha256 cellar: :any_skip_relocation, monterey:       "0382775846be6c0c41ea0480e00a6b943129234a2ee1de631cbbd047ae282779"
    sha256 cellar: :any_skip_relocation, big_sur:        "199919679c3155cdc6e1dc6b6e3140ceda383ae730fcf5c493c75fefc66f0f89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d6d70e2c8801fc40f5f7ac3853ecc34512cd8c87a18c3336087ba6b4c084366"
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