class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekit-cliarchiverefstagsv2.2.1.tar.gz"
  sha256 "b78bee20d70d190a43a65a1840e268aa2ac3661011cacb0717b235652b322e65"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59685a544c9d54781a0dd0f06fe754f0dbb759b3101a5adf42a9655e15408d0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59685a544c9d54781a0dd0f06fe754f0dbb759b3101a5adf42a9655e15408d0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59685a544c9d54781a0dd0f06fe754f0dbb759b3101a5adf42a9655e15408d0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bfe3fdad2cda79b6391cf85367cb8df0f6de18a4ad7fe5ea1da69c8af9ab364"
    sha256 cellar: :any_skip_relocation, ventura:       "2bfe3fdad2cda79b6391cf85367cb8df0f6de18a4ad7fe5ea1da69c8af9ab364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf375fcbb312921c7d70492e4779f1d92c099006a91452ef594857b1e0072949"
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