class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.8.5.tar.gz"
  sha256 "33a0b683a6b7f9cc4ee7b0306fb392111a21c2cf37434716630c40e27722802a"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3612d43426756b968db442031c72c35912b428ed8786d36dede417278c551a0d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0214aae111d76789dcb481557a510632e5264d575d422c18d805865350b67be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db4eb1583877e3ef1ba60f32bd3d54d3a57ea82be7c899717ed5aec471d6cc58"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cead6e48fcb408214df687659d366d42143c23b62d70e350997ca7a1bebf630"
    sha256 cellar: :any_skip_relocation, ventura:       "d6a5258d2269475a6cd85e914327b67e0ea2f5802f846d0dae647eadecdf85b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "073e8991bd5ada5d98fbfb3e0fe427e08d5ab82c0ec2dac44e838027573a9952"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tv -V")

    output = shell_output("#{bin}tv list-channels")
    assert_match "Builtin channels", output
  end
end