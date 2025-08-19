class LivekitCli < Formula
  desc "Command-line interface to LiveKit"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit-cli/archive/refs/tags/v2.5.1.tar.gz"
  sha256 "a3221ffdd7c327c34729a05457f82d791d67448d76b58acce7e41f0b1b6fea08"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c3b1098521041053fac46c41937c01aff7c5a6509eda47f3e77e04f32e1afdb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a17f88776f60baca48f0ea5acbe97b6ab3024632e45b3ab811f4e4e77470db6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f5819f246dae75f96f6ac2b33a88452bb45847b63be9bb5b7ea393ec3c84576"
    sha256 cellar: :any_skip_relocation, sonoma:        "369c30061db270dae461385213559da70d01067b1584088fb9f393b697809442"
    sha256 cellar: :any_skip_relocation, ventura:       "cc6fad5b71558c88c18592db7b9596487fdc115ef9a26b1c646748fdea017541"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94d2329d365c1863388be1eb76a13bb84a9c49943f6d29e824b6df8aa8277cfb"
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