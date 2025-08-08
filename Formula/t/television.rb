class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.13.2.tar.gz"
  sha256 "60a52cf7b1bf5966c4eec331c474fc21f4abfd2c7023773619e05e8182794288"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23a8eda60e600dde7d1a01408e1dcb0a426aeb5574c4c10cea11e1989709a469"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82a70ac85398e86554e648d3fbfd35163258f7fb6057d98daa1965e314203ca7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15278513415ad46c5a75f14736fb345d9c0beab22b5b7f87567f08c0fc01fb98"
    sha256 cellar: :any_skip_relocation, sonoma:        "e784ba9f083ec5a17bd0c6a85ef1cd4b6746541d2821f88ac923ae305c0f5b30"
    sha256 cellar: :any_skip_relocation, ventura:       "6d7c236724b87da14a8a591d5840d6ecd08897a9cc37ac01198aa9cb42615076"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0361658545760c5f240f8a438a3ab2529ab8ed0f68130f785e6ef2c1845ac8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a89d44ff25cca9ce3a75e4b533ab8b5ab53d3a5bd571ffedda90ef24e732d68a"
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