class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.8.6.tar.gz"
  sha256 "ff76862f8fdd5473337ef783e74c377b8bf65eba7e4a437832793a4442b310b4"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "350554fdd98129bbb8ca4cd3302afa193571123e71f838fd78165c19ea621bb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5d1d9902effd631f3f447b37a3573a1886f628852a020e4f70fd8021ad37d16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d18636bd2df627837c7c4f7b3fd70ac3da8e1141a00788b7cf3fdc95093b83b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7fd4262e68cc847ba9a2bcf9547eb1e8ee887a25ae8c5bdb70375393e22cf9b"
    sha256 cellar: :any_skip_relocation, ventura:       "065e25d8083d0a5760b78525d2ab92b649d6800f3f6dbb58b3bbeda0826bf3b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "69dae24aea3ae3a57f63e702da26ae82e8f37c361a66a109edc416a86fe9687c"
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