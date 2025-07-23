class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.4.14.tar.gz"
  sha256 "5fec3785996d3de0450290329d6e0ef52bc7611888c6b3ef1e0023f73c15f6c8"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16485fa9a443a042ea61b8a2bb9d9be8d0c881db07a3a2868acfe46d615220aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e454b2002d9c2b25612dbb92ba345fdc547e45ce591e39815512f8c4dfb5895"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "717493ef72bbba5cbbdef575d81ad638c557c556ff98505771b2277e203b77b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "51a92407686369a81f04821e916b206817ab4bb1548cada24e43de5de6b5bd61"
    sha256 cellar: :any_skip_relocation, ventura:       "23b61080268b7cdb488e24083037dc4fcee9021bf7572653c4e797eec0c0c2d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f565fed2211c0826247c6bb0d03faa69f4094807834f864c0e51ac9d88a0803a"
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