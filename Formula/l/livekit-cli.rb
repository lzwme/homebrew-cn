class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekit-cliarchiverefstagsv2.4.6.tar.gz"
  sha256 "b0715b4f25bb1df0cea4fd2028a3096aae01aec1dc774a2749a8895d3bd8fec7"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6f3ac27a6e1254d1be90dcef6d6c1619215720d6679fcd527f659134d69d0d17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f3ac27a6e1254d1be90dcef6d6c1619215720d6679fcd527f659134d69d0d17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f3ac27a6e1254d1be90dcef6d6c1619215720d6679fcd527f659134d69d0d17"
    sha256 cellar: :any_skip_relocation, sonoma:        "0643847c7c56e60066f3b335298eb31a442e592023070f6f6abcc161e86f0e17"
    sha256 cellar: :any_skip_relocation, ventura:       "0643847c7c56e60066f3b335298eb31a442e592023070f6f6abcc161e86f0e17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94ecc997d55f7b38ef5ba60dfcb40ae046625a8565ddeaaac610beddc128a170"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w"
    system "go", "build", *std_go_args(ldflags:, output: bin"lk"), ".cmdlk"

    bin.install_symlink "lk" => "livekit-cli"

    bash_completion.install "autocompletebash_autocomplete" => "lk"
    fish_completion.install "autocompletefish_autocomplete" => "lk.fish"
    zsh_completion.install "autocompletezsh_autocomplete" => "_lk"
  end

  test do
    output = shell_output("#{bin}lk token create --list --api-key key --api-secret secret")
    assert output.start_with?("valid for (mins):  5")
    assert_match "lk version #{version}", shell_output("#{bin}lk --version")
  end
end