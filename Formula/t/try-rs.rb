class TryRs < Formula
  desc "Temporary workspace manager for fast experimentation in the terminal"
  homepage "https://try-rs.org/"
  url "https://ghfast.top/https://github.com/tassiovirginio/try-rs/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "3272032c453321fbb7a9d5afe0df0579f35bf81c7f275fb9d1cedc800f203eba"
  license "MIT"
  head "https://github.com/tassiovirginio/try-rs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "72945a7686d8b3cce27930e5f5a4a8627e0a3ccf238f87469023c591c18271df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f4c9a6f197716671b00c286a4deb6a8d2188117884cca8adc62065696292915"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbef30e984140a872ce645c30cc40da07466cccf7a13804807c2ab2247ccac8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "757362b54e87e9340e8d92322f164a3d06fcb5d5ed7343e0817572ce2d7db090"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f05e5eeac6054e6a865fd286d7424c39fd15d4404c0cf11b4b0d356327a6fb46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cc441a6b8ad6190a82979d79982a777e02ba57440587fe0253b9d9780866a54"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/try-rs --version")
    assert_match "command try-rs", shell_output("#{bin}/try-rs --setup-stdout zsh")
  end
end