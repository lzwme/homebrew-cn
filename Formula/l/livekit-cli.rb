class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekit-cliarchiverefstagsv2.4.9.tar.gz"
  sha256 "92d017478f4b95e2756ed6292932a2668ac027c0bef7a0748d72192cbd48a9cf"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b571a9f3b3e7c4d4eac1eeaf9486ba6b3ff558d717b01bcc722deec829e75cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b571a9f3b3e7c4d4eac1eeaf9486ba6b3ff558d717b01bcc722deec829e75cd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2b571a9f3b3e7c4d4eac1eeaf9486ba6b3ff558d717b01bcc722deec829e75cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "84040615d95c96e1cae68405db375adbd2601131312d0c6e5b5cfbad82e099f8"
    sha256 cellar: :any_skip_relocation, ventura:       "84040615d95c96e1cae68405db375adbd2601131312d0c6e5b5cfbad82e099f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e3b830b1ec80a6e37c241810cfbb1c0d4e10201952ed43e372c2871c6a644eb"
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