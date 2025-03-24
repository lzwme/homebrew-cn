class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.11.4.tar.gz"
  sha256 "c4e8a87d65135fb5a6006c7c08dd34cf6aeb24c2d59e9ea6772e9ff714bfed29"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efd2e76996966b126f7f3ef20e65f2963f5e06ea5ea63608c349f53f9d38fa84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd549752a13d54f96220ade74f754cf006c96e9192237f0365029415de272fa3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5eebf67d66dabd9692a7f3240d0aa913a76f673da4f968f78a3fe278ebae2fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "d20f81a125f104c4b5e33e0cf9a2ffc8c61b7078b35bd92f04a76dbde9bf97e9"
    sha256 cellar: :any_skip_relocation, ventura:       "65a375cf29850309acbc15fe05b3826fa92a31977beeca92cefe5ec7529ca679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10b235e09f546f994634907c6825056f58375a4f0b13a05795850ef3d3cad8bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17ec72328fc12f1d59c90a315c06d6567bf162d3c0b123c526afa99cb73b2b5a"
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