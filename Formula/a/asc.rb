class Asc < Formula
  desc "Fast, lightweight CLI for App Store Connect"
  homepage "https://asccli.sh"
  url "https://ghfast.top/https://github.com/rorkai/App-Store-Connect-CLI/archive/refs/tags/5.6.0.tar.gz"
  sha256 "8a3317010866d3c642f7fbcf68220d640c953c4c6c7969b46ae97beecd3b6b78"
  license "MIT"
  head "https://github.com/rorkai/App-Store-Connect-CLI.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "dc7e86bf5d534cc0bc8544534860acbcce431ca33c72405dbf7211f4492a831e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "531c158283bfa941f072c78da3148cc60f36b8fc2f09ee038e0a68fc763db0da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "06904c39f2a80e54915b6fc03b99166b290639180b8ced0c51570dda4ffce508"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f27e5ecc30e0c034f9cbf91fbb9602be9b74eb7e59e5f6fd4ba59d051ee15007"
    sha256 cellar: :any,                 x86_64_linux:      "cea5980e6561fa435ab1e2fb6bffa2ff42f0106b5c50cfe1df0a66816f7544d1"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"asc", "completion", "--shell")
  end

  test do
    system bin/"asc", "init", "--path", testpath/"ASC.md", "--link=false"
    assert_path_exists testpath/"ASC.md"
    assert_match "asc cli reference", (testpath/"ASC.md").read
    assert_match version.to_s, shell_output("#{bin}/asc version")
  end
end