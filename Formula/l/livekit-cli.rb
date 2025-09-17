class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.5.5.tar.gz"
  sha256 "9ccbbda99197b8e8e7518c460f626e80754c9272530d1a7778138b0516638e0d"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8ef50ca0e54d3e1766381f6205c4c392b62e61ac817c8a2b9514d527471604f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "062bccf6376cb73190d189bacf78e7c09c625c32cc6c6e50cb79d8a08d53e5f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca0a7ace358b0572386d06f76d814f3294b541740e32f24663a6cd9640b4ca95"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cefaae90889398181aa47941c1fd3b3e9c4e6b145bbc55f00996067790597c3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7ba8fda1a1ca077dba15380e82a7b3c9b5196fc974b476d9987ecab88594c21"
    sha256 cellar: :any_skip_relocation, ventura:       "a14d04a88fc44e1af7942e4cf4e88ec7b53215d47fe4c07b6a89c34e4d3dda1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "35a5299960075158141529d664edd206de5ad685c72a578edddfb833df2694e3"
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