class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://ghfast.top/https://github.com/steveyegge/beads/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "2d42cf8b452ad7c1b40cd0876c01caf5cd3361c889a86a58105ed1fdc4addbb7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "729870f82bbe5e4cd871a67316b5d1ed8e9172c006d52279d5e57105a05cba24"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "729870f82bbe5e4cd871a67316b5d1ed8e9172c006d52279d5e57105a05cba24"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "729870f82bbe5e4cd871a67316b5d1ed8e9172c006d52279d5e57105a05cba24"
    sha256 cellar: :any_skip_relocation, sonoma:        "e424da9958fde845b88a8b0b76126f3c6be5e40cfd93c06640239452afa6f27f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6511aff2700ab683596934ee43a3cbf4ba621797f176482114981839bcac0fbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f010d324b00a19939af1054e925c150f1c0155ca13e5ba925f7e15f91504423"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/bd"
    bin.install_symlink "beads" => "bd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bd --version")

    system "git", "init"

    system bin/"bd", "init"
    assert_path_exists testpath/"AGENTS.md"

    output = shell_output("#{bin}/bd info")
    assert_match "Connected: yes", output
  end
end