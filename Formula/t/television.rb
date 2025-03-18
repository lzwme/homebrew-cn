class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.10.9.tar.gz"
  sha256 "a3892e2673273b0eaa301e25e2247910e28ec12bce2c9b5a31f2b2ad18ec3f7f"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5415663d640515581ccc625beecbc21ce3ced7c889f61ab3fc7d3ed739705e7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5024e20a1b95eed6f46d315d88272bad89552c21f19333ee1c7ef7030741303a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "46e3f1c5774111822c274ed0e544c541fc319af8a0dff8a4b96bf063fbced274"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bc0ec11f2c35ca13c11720e4c989f998af6d2c95b08aa7f00e8bc19370fc949"
    sha256 cellar: :any_skip_relocation, ventura:       "c33c8059025886f273448db57a5eac3cb81c54eb1ced648b4835431f7aa07413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b94fba5611ab65d34e7c380c9cc87fa34179b3d1f61eac73cbe0a91a90f333cc"
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