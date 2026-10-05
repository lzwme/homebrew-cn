class FxAgent < Formula
  desc "Tiny, open, embeddable, native coding agent"
  homepage "https://fx.sh"
  url "https://ghfast.top/https://github.com/vercel-labs/fx/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "bf2977563f2ded63ca5972cf3544f66c205d6b6533ae1101c04eeec266a3468c"
  license "Apache-2.0"
  head "https://github.com/vercel-labs/fx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "60e436fd5f533bd0a3b5a2cc804e86c7a15e91238f559d84957a05a583bafd9e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "56177514357a54f4e92c20c3aeab8d38595dd985382269888d20156ad740352b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "30c13031b4486052ff584a4a6e53a42d069e88e958de5a2a632ce35f7d6f03d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d5e8e22043980e9c6f922ddf97219c26e729d94fbd864ac56ae1e7b3c0d75002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c4e667833357128adec07443ddc6b961f23399d2d5214b1f7329bdb9a46dd584"
  end

  depends_on "zig@0.16" => :build

  conflicts_with "fx", because: "both install an `fx` binary"

  deny_network_access!

  def install
    system "zig", "build", *std_zig_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fx --version")

    output = shell_output("#{bin}/fx ask hello 2>&1", 1)
    assert_match "fx needs access to Vercel AI Gateway", output
  end
end