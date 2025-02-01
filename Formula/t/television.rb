class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.10.3.tar.gz"
  sha256 "b1df3632463982f203ac8682534f1e34729c7d635aab7dc45bca4877b56f2585"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3726563114577ff99347e74ff89f6f91d01f315708b5c5fbd94dd57bb5b5111"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a974d4a4b393ab0a9b461d0be7cd7a66d8862b60e745fb2fba9e81a0ec70454f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "244e79b13a047a314e17aa2258415f76e3cce004db3c9e56e7b255b6e007809c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0924384cc92906f2e54106afb4b4cf94f0aa756e0cc68dceae6a9e595cddf7af"
    sha256 cellar: :any_skip_relocation, ventura:       "67839db25a9e5423445a0720f539d97adff6832ca762f3162609689397b979e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "430ebb1db3228f9dc4b95012ff95fc6f284845c85f0df320c4a3958253c4fa4d"
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