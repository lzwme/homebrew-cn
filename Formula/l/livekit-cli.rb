class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https:livekit.io"
  license "Apache-2.0"
  head "https:github.comlivekitlivekit-cli.git", branch: "main"

  stable do
    url "https:github.comlivekitlivekit-cliarchiverefstagsv2.3.3.tar.gz"
    sha256 "a01ce7e297566aab77f97fabf4a4fe13755a5039bd35a5e440c9e94630125bd2"

    # version patch, upstream pr ref, https:github.comlivekitlivekit-clipull521
    patch do
      url "https:github.comlivekitlivekit-clicommit9a8ecb16d1822d1ec5fe3d78df91ec93dd7e6f4b.patch?full_index=1"
      sha256 "ca323f16e12ab9afaa129c27ecd24d82f18d68404b4d05d6dd0cdc43255278e1"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8d6c5ff4844f6d3da36ea78a7ac94fc8b1ad086a66e27c997a8aef81dc210a32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d6c5ff4844f6d3da36ea78a7ac94fc8b1ad086a66e27c997a8aef81dc210a32"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8d6c5ff4844f6d3da36ea78a7ac94fc8b1ad086a66e27c997a8aef81dc210a32"
    sha256 cellar: :any_skip_relocation, sonoma:        "1179da87f66c3d90513b012262168a28e2c2976d32bfd337984f45ca4c1f68f7"
    sha256 cellar: :any_skip_relocation, ventura:       "1179da87f66c3d90513b012262168a28e2c2976d32bfd337984f45ca4c1f68f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5431e35b11f5920ae906e70b52c6937ce1d445a2a7eb5d929072aa3e94791d5"
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