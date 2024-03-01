class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.8.4.tar.gz"
  sha256 "95c808986a1081586895234508ab5893b34618a2803d650c50e9959b586a240e"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e733173e1dda192f591caf1c206144de30fd48a9f931cf1fffb7146c7a801206"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac70474faeeb641243863574cd69817af4941ee1b8ca88fa836e620d40ccb640"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4462a6e189c3d9481baa4b675a4269bc2994bfef3c22dad4f814e0f1091cdd7"
    sha256 cellar: :any_skip_relocation, sonoma:         "ba6eb66171aba5c1561f2d6b8744b44b7fb91aa15230dccc80771b01ee98f325"
    sha256 cellar: :any_skip_relocation, ventura:        "59e884cbd6abad133c15fd06925a23484945cf5a967b2b5bf71d4be5d296504a"
    sha256 cellar: :any_skip_relocation, monterey:       "722839f31dc8a08faac869341f17a63e1fa6f8587c6b533f6214c6a892806ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aced1b6bdc90f1d0b83e9d638639fb82a858c4b58b03dc304aa56a50eadddf23"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags: ldflags), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end