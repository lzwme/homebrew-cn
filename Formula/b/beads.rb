class Beads < Formula
  desc "Memory upgrade for your coding agent"
  homepage "https://github.com/steveyegge/beads"
  url "https://ghfast.top/https://github.com/steveyegge/beads/archive/refs/tags/v0.46.0.tar.gz"
  sha256 "e6fdbca8b1353501205e7ad26314384709cbc8100cd9ef8ebc83aa0bc8a1a976"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "386040a43befa94fbd51394aa69912482ecbe3780e950ae5d8029a6a2bee1f86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "386040a43befa94fbd51394aa69912482ecbe3780e950ae5d8029a6a2bee1f86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "386040a43befa94fbd51394aa69912482ecbe3780e950ae5d8029a6a2bee1f86"
    sha256 cellar: :any_skip_relocation, sonoma:        "7700f61b4a21d2208ea56899bda0e89e1c424a10c3e45445d3e5c5085b87d5a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9be580c60b43b0c16e48199cb93c7eb0f19430bae614cf368cce90730b52654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18272ec25223f77b74d774de2b612fe161b820a949c30a2d05593d6f2b227c37"
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