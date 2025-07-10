class Television < Formula
  desc "General purpose fuzzy finder TUI"
  homepage "https://github.com/alexpasmantier/television"
  url "https://ghfast.top/https://github.com/alexpasmantier/television/archive/refs/tags/0.12.1.tar.gz"
  sha256 "ebd94323abccde52da762409fd6f4ef17e56942a40677524e8f380ff1251848c"
  license "MIT"
  head "https://github.com/alexpasmantier/television.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b71de04878ba91812ff706bad53faf9c7e5e95c228e5b8e3874432ad2b2551c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9556b560727f050a7002ab7ccef2dae88b2df0c21327950c8070d3530aef0bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "722077dccd539fcd0aeb288fc8ec2d53f1bf21bcccd4c3377a8ba4a85403c972"
    sha256 cellar: :any_skip_relocation, sonoma:        "21675af6202080d4422ebb1720fadb936a398974e1974708c3b09618e277fef3"
    sha256 cellar: :any_skip_relocation, ventura:       "7843ebf0b9c5b20a3e802e87029e402a621c07fde8a9d2939c6c52ce8ec9b79d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "592d6000ec51352d40423c4ee5524d3ad36354aa6a3fae47685872613d9e0cfa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5084b3cb3a1c61f73ddbca5c9909b2c0077545abb414b1e2cf5991383d1352f6"
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