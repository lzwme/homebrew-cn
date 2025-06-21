class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https:github.comfiatjafnak"
  license "Unlicense"
  head "https:github.comfiatjafnak.git", branch: "master"

  stable do
    url "https:github.comfiatjafnakarchiverefstagsv0.14.3.tar.gz"
    sha256 "cfc0fb5899aec2815669c00bd66a13e1f3be31469807bb89261ad3a0f125b6c1"

    # go.sum patch, upstream pr ref, https:github.comfiatjafnakpull70
    patch do
      url "https:github.comfiatjafnakcommit35ea2582d814ee2d4855fd27a2789c26f1ea2186.patch?full_index=1"
      sha256 "32ce06fede5d111003c3fc73ea742b55574bab1462b5fcd9459cd282b9415195"
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d251de9a637a5934ae6cd19a91fe99aa763b24c677329a8b8f28224a0e8c5ab8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d251de9a637a5934ae6cd19a91fe99aa763b24c677329a8b8f28224a0e8c5ab8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d251de9a637a5934ae6cd19a91fe99aa763b24c677329a8b8f28224a0e8c5ab8"
    sha256 cellar: :any_skip_relocation, sonoma:        "be23696629cf433910d33fb5d903cffd6ab4cf33cca1f667d25751477f30d682"
    sha256 cellar: :any_skip_relocation, ventura:       "be23696629cf433910d33fb5d903cffd6ab4cf33cca1f667d25751477f30d682"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ff549be87e4855a893c6f3e20a9a2e939ccfc0aff6f7d948f39af5d26a8a663"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}nak --version")
    assert_match "hello from the nostr army knife", shell_output("#{bin}nak event")
    assert_match "\"method\":\"listblockedips\"", shell_output("#{bin}nak relay listblockedips")
  end
end