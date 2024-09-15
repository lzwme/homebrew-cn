class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekit-cliarchiverefstagsv2.1.3.tar.gz"
  sha256 "08c4819cdea8e59d7ce3b4c675e36a4b123f1d3bcb23080ad14a1db0826801f0"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1a4b6b043f0e494fb4174ac57edbd63d2d1aad6a26b0ef63f4d47b984d0711b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1a4b6b043f0e494fb4174ac57edbd63d2d1aad6a26b0ef63f4d47b984d0711b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1a4b6b043f0e494fb4174ac57edbd63d2d1aad6a26b0ef63f4d47b984d0711b"
    sha256 cellar: :any_skip_relocation, sonoma:        "8362eb37f13b37f2d9b238f3230b5d758ec9ef1ffb9759f03289b26c280d70de"
    sha256 cellar: :any_skip_relocation, ventura:       "8362eb37f13b37f2d9b238f3230b5d758ec9ef1ffb9759f03289b26c280d70de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b07a6ecf52a8e11fb1c7262c434ea5dca789376c02a1779440531a0dec04844"
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