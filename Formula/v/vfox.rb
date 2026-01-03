class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https://vfox.dev/"
  url "https://ghfast.top/https://github.com/version-fox/vfox/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "5c82575fd0ae78c2866862375861a7e69a92e1175d8f9bf89d48db14b993a4b7"
  license "Apache-2.0"
  head "https://github.com/version-fox/vfox.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dee3e01bdcc226cd6fd5241c0c0966369cbe473b00574e042c981cc3e8a1d0ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5053c020ad120834b7d0ce1e42da4d5cd001a4e2c79684a64dc91733367c9c73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c3ad799784f955be767920bfbdc213aaf367aa88d7dfca90a7b6dc026491a0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d56177cdc7c31af47b29f451d8878a753ab7c0e1fc7b28ec82760d32b01d5d12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2599e27bfc97c3da4470947714aafba0e0d5315f973cc699542e97e9c9674d6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "029d6dcaa4c8738e4b7562acc9d877d423ebba69065f4fca471ec87430c6d1dd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completions/bash_autocomplete" => "vfox"
    zsh_completion.install "completions/zsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vfox --version")

    system bin/"vfox", "add", "golang"
    output = shell_output("#{bin}/vfox info golang")
    assert_match "Golang plugin, https://go.dev/dl/", output
  end
end