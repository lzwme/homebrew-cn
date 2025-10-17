class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.6.3.tar.gz"
  sha256 "b70d3575ea1dee2d31cbf0fbe08fa66fc451eddf6bb3e291c72447bfbe9c08b6"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80e7203c4f643cee73c0fead049c1469646a74640ad11f75108327d8bb770b0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e7b2bbd699ef1808c1d32f6c29136a97d14155ea0f1846f3a6f1da9d6d9b027"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1f6068478a56f6b5f54eadbf87da9d53b9dde8e7d2c9725353c9abdcbe41d64d"
    sha256 cellar: :any_skip_relocation, sonoma:        "24451b39ababcdccdc2ad361bbcfc36b9995ae135079d9af6a35c228394a24c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c59b35952f118465978b0c78425f5c5d6c61af8c3dcb2297839ec2ea999f8ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70b74a177eb04af71a9da6cee04e1820dbfb6523f0d1ef3d76d6c51708d0605a"
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