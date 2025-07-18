class Vultr < Formula
  desc "Command-line tool for Vultr services"
  homepage "https://github.com/vultr/vultr-cli"
  url "https://ghfast.top/https://github.com/vultr/vultr-cli/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "b45592d8bce6539b6b35e405f71a3ac4bb6fa3ef5ad4ec8b6a1f31c31f17cdc7"
  license "Apache-2.0"
  head "https://github.com/vultr/vultr-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d92694b6931e84ff9587e68405d40e2a6df2c8935edca297e82961cdfae94063"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d92694b6931e84ff9587e68405d40e2a6df2c8935edca297e82961cdfae94063"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d92694b6931e84ff9587e68405d40e2a6df2c8935edca297e82961cdfae94063"
    sha256 cellar: :any_skip_relocation, sonoma:        "a95b6a24c04d470ed092119a9684910c1a8a70c008ecc84857703183211b694b"
    sha256 cellar: :any_skip_relocation, ventura:       "a95b6a24c04d470ed092119a9684910c1a8a70c008ecc84857703183211b694b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c12cc6b5c04635633f61435eddf9739b90510a3734844ba6deb3d4a5c26c0099"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"vultr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vultr version")
    assert_match "Custom", shell_output("#{bin}/vultr os list")
  end
end