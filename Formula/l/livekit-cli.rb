class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  url "https:github.comlivekitlivekit-cliarchiverefstagsv2.4.4.tar.gz"
  sha256 "2235aafc17b5c885ba6535446b9e1a47f46fa68cbc5f6099c9f7d8b1d5d025e7"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e9045373a6c8e4e01487f0a09e3fcf8e3de6e658aad3c7368a2789f497855419"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9045373a6c8e4e01487f0a09e3fcf8e3de6e658aad3c7368a2789f497855419"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e9045373a6c8e4e01487f0a09e3fcf8e3de6e658aad3c7368a2789f497855419"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fe4fc2c7830cc8ecd68143a30eb9524cade6717b2980dd8155525e1e4d300b2"
    sha256 cellar: :any_skip_relocation, ventura:       "7fe4fc2c7830cc8ecd68143a30eb9524cade6717b2980dd8155525e1e4d300b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c759ab644aedba6175bb9fb82dfc2b9fa2d1c80a2ee29b6581c1356013643c3c"
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