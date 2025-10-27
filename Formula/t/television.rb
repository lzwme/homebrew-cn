class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.13.7.tar.gz"
  sha256 "aa2009f5df526bb8ae0fdd4eb644fc51bf50eeaf093a8609c4dd7453fd043a54"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9724c6889d8b3f5bb7e64da4d5130d7472f30fcfefb25417c6d8297c280887e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4098f9e333e85d7aea345203f7eee5a82b9eecee28633c1e4e12105c55eb1136"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be6eb80ba769e1c7d387b1118ce4ff2abc9f68b1e605953d2ccbd4becafcc216"
    sha256 cellar: :any_skip_relocation, sonoma:        "72b770eb892a4d7ad716716cbc8b2a676874bd70bf8d3b3e317dfd72a5be9ef3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b40f2ce867c776bc7926bf2b9f9b61afc328862c4a2cb3bb3e4c6f2612aaa70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05834abe075d811a8029d53f8f94a0aaa34ef579179566b8131e237edfc32e90"
  end

  depends_on "rust" => :build

  conflicts_with "tidy-viewer", because: "both install `tv` binaries"

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/tv.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tv -V")

    output = shell_output("#{bin}/tv help")
    assert_match "Cross-platform", output
  end
end