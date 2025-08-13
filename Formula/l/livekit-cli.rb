class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "9e4c6a2437b77181821e3dad2fe755f90ce1eee6fe3cfbd6641693142e98fd50"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52f6ac6464038d8b6e8143d8b1c66fcdeda3d37555b2ed4f4ff74b276adb7969"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb96b6b4b8860364e47fca0d73131f7414db8409cbfaa5d8db5ae7eed988b2be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "623ec20d7c562563c19d8eadd2de31be31f5e78c2b905651892b2b02111380d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0f360bc1d61f04475f5b71e223616a8ad8f0fc0ae0ca5a5989ffd79620d446e"
    sha256 cellar: :any_skip_relocation, ventura:       "271b7945f30eae7726f5169f4c277949ea1ff5321035ae536e19142b10714511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a9693cd5d843653019faeba01d91751bbddb82f910ce070962d8db97c93b9f0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin/"lk"), "./cmd/lk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocomplete/bash_autocomplete" => "lk"
    fish_completion.install "autocomplete/fish_autocomplete" => "lk.fish"
    zsh_completion.install "autocomplete/zsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}/lk token create --list --api-key key --api-secret secret")
    assert_match "valid for (mins):  5", output
    assert_match "lk version #{version}", shell_output("#{bin}/lk --version")
  end
end