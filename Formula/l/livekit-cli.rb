class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.5.2.tar.gz"
  sha256 "f215e7694ce34402b9179e0e10f659472dae87085a2cb16c6da36f716c6a8458"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ba57ed7c73673dc66b9fc71a3f12ac7cd60359c7746f9553a3975a11070d206"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0617a79c04f05aa281febcde38c76de8eeb56239a5b1bb0f2d7ad1c14e44d25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "febbee325ab71d9d16e6d411411266c24b809dfca130fcd620a56b18e7fb9a8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcc35ff43bb31db7b2b3e72364946c19f939661c7967aaaa99cf8f78b92ec443"
    sha256 cellar: :any_skip_relocation, ventura:       "7b180853cc1799140e199c2ee61df616cc02b25d03bbd4dddd9b1739f5d89f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "312bdd78a05c34afb85f5691cb576d82c09f10f501da5943dd73df62463af1b9"
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