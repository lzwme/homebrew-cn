class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https:github.comalexpasmantiertelevision"
  url "https:github.comalexpasmantiertelevisionarchiverefstags0.9.2.tar.gz"
  sha256 "93f82f33e699a4a91f0015d88856a7fde5ae95bfa132a02c08518ddd264256cb"
  license "MIT"
  head "https:github.comalexpasmantiertelevision.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be25bd5a853143589f12e06d786b9efd1926b15e6cd7ca16f6927b6fb9f8b527"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82b9a04efa193c5792fee03b1e0fad2906bf85d04e2822feaa85f47e32ee95f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27a1f9f115dbd008ab759487c525339ce6a435e2fd6be81ee0772e82114dc8b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "110adaa6898554724bf536dc48142a130068e347f1e5f01102e161076359b72a"
    sha256 cellar: :any_skip_relocation, ventura:       "2038590860765ff92248e2a7f658f83bd8d4d207c165236fe1b27b1cef56cbd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "944d99eac949319a1f6d1eb1a02898528821dfe4bc5e25f81e7cc38e76e66b11"
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