class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekit-cliarchiverefstagsv1.5.1.tar.gz"
  sha256 "55b31b8bbe639d4c2c78ed61e7e84b874a0d1ccd2f80e92dffcb392deedf1805"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1716b8893a32aa981a5db2bf21e3a8d75dd73931ef2fd7809bc91e1b45d58d80"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1cdf1a22d80a5f40b860642205426cbf75517937e7c21105e831a28afa8df1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a69a81faf71aec28a2179c4b67901e2663f6200390a82ae193e921f60c06816d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a0f5249a07b0d0fc45486f54d5b27f8ce10647dd74647f62931772a77990fdb"
    sha256 cellar: :any_skip_relocation, ventura:        "d647cc1f0ae3edb8c22113db063327a8bd962e7d33248835c4b2576de7636723"
    sha256 cellar: :any_skip_relocation, monterey:       "5ed47607d646b1910adc30b2827b5667ac1ef5837c8b8e7722f4dd45be89b6f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d7c21883a337d7c38c9f3d58cb3637698851304559f2a8b32eb75fb06ac14cd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdlivekit-cli"
  end

  test do
    output = shell_output("#{bin}livekit-cli create-token --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "livekit-cli version #{version}", shell_output("#{bin}livekit-cli --version")
  end
end