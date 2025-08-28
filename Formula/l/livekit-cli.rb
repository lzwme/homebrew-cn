class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.5.3.tar.gz"
  sha256 "0829509fd0f1e92c65249959c53ab65a406e76f88a04f21347323072bc0118dc"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbc73594063d280231ed6f4fe4996b09790df0dcb2090668445ac455b512706b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a3736e7d0d4cf6798152e2c28bfd9634aff201cf7bc54dcc096d6b43585e00d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8e8165bed960d0f6ce23285559fe918dc1189f84fc5d0fec7dd48e9d2e5f5d4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c192a33a25e074b0492cbd0a50d0afd9c815cc84720c4184fa4381e52b7b85e6"
    sha256 cellar: :any_skip_relocation, ventura:       "041d170500a0e964e4f1d00e1cd775ae454803d37309846747666af198c5c0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "300c877f3fdac46dbda0324c3f7bd5e7de2b1fb64fa0c751a7eace2e9d5899f2"
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