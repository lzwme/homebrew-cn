class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekit-cliarchiverefstagsv2.2.0.tar.gz"
  sha256 "36e21c5c71d800fe143a50ed1bf4a8715442dd22aeacf8e571ed3df74ff83ed5"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be624403e0097a5812adde65ca86ba0d2603be14bee3bb549b4f4392d08f1e95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be624403e0097a5812adde65ca86ba0d2603be14bee3bb549b4f4392d08f1e95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be624403e0097a5812adde65ca86ba0d2603be14bee3bb549b4f4392d08f1e95"
    sha256 cellar: :any_skip_relocation, sonoma:        "54f1a75ddb37a1c773b42ef2581e95c46b007d1216d24dbb700c45afa9d669ef"
    sha256 cellar: :any_skip_relocation, ventura:       "54f1a75ddb37a1c773b42ef2581e95c46b007d1216d24dbb700c45afa9d669ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7195dc8e1401cfef3b767ad32ee3713baa2e4069b29c47d0f69ad36a88e32212"
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