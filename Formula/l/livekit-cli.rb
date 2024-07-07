class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekit-cliarchiverefstagsv2.0.3.tar.gz"
  sha256 "56da9d55d3b09ef4ababafaf678aad018b2d3d8b3001d888fd6aafe04b33aab5"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "190bd21a53e673ea3e5fd6d70ddf776e55aad253c806da456c1ff46666a467d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "137e934f591ae48059eb464f33cf67eb7d3c8355186841fa5cba5fd100c2a26b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa013d96301e420f3fd5b089b634ade85c25762d6b87ddb05f23273a08203c59"
    sha256 cellar: :any_skip_relocation, sonoma:         "adaa714139e39458b7bf16571f132b555cf3011832365413f4a3fdd8e430fc44"
    sha256 cellar: :any_skip_relocation, ventura:        "da5247143a54fc652f336c80bcc29b09cd62e180f0377dd906d764181bc2e85f"
    sha256 cellar: :any_skip_relocation, monterey:       "3d6bc15d64af24c87b4999948e1b1758a2137dde7878c8d34dfabfdababfa045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c30ae9c2ea026d2d257fdf9db98c4b3257f41a961e938dcced5c307a75fd67a6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin"lk"), ".cmdlk"

    bin.install_symlink "lk" => "livekit-cli"
  end

  test do
    output = shell_output("#{bin}lk token create --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "lk version #{version}", shell_output("#{bin}lk --version")
  end
end