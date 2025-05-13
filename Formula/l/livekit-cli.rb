class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekit-cliarchiverefstagsv2.4.7.tar.gz"
  sha256 "6e961852116577b11a057e739adc6ccac72c8d52fa2934cc0e2a94b5319c4db1"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79dd2fff1e7b3c1cdaacd79bda856b370e04c96e4bb2f5f46366ac0aae93023c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79dd2fff1e7b3c1cdaacd79bda856b370e04c96e4bb2f5f46366ac0aae93023c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79dd2fff1e7b3c1cdaacd79bda856b370e04c96e4bb2f5f46366ac0aae93023c"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd6ccebe5a4d88cb615983e2b0ef668534885c646545eaaf5832aa634827a80d"
    sha256 cellar: :any_skip_relocation, ventura:       "cd6ccebe5a4d88cb615983e2b0ef668534885c646545eaaf5832aa634827a80d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c376dadf60c2ed4ab268bc998b10749a0328269d9fd6c57528174baa70a7140d"
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