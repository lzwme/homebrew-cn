class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.10.5.tar.gz"
  sha256 "ede01f4e4a7c35bdf8a77c5574bcb52f305157dc018859f784c2bb1281a1db7d"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33fd64d6ec483d8511ab753d0c3586f9a2845facc207c51360e99d380e34e1bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d125147137870ad14fcd00442975a2be35aac65f6c22fda053f2dc18106bb15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "814ca08a50858cd6b40cf3966ba2eace256b8514643259dd147b204bb894a026"
    sha256 cellar: :any_skip_relocation, sonoma:        "efd54a74f2159d0ad5a8cb27d5d8915f3a493d8c2fd19f85c6d4bba3013c1e06"
    sha256 cellar: :any_skip_relocation, ventura:       "8b1faf9323f2f570e0ad05b2f2ce8fe11fd8ad8e19aba117449e99e13209fa28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d60f18c5ac53f44b1989134f2347c01506c4e1bf29817a95d4d54122a31ddc51"
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