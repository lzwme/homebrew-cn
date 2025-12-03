class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.17.2.tar.gz"
  sha256 "098ebfc88f8b67eed705cf4bf6f8b86fbd78c9f884eb7147e2568cebe6fe6548"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc44c03268610698f7c5309e9dcb092d3321ed3d9623a29118b6089b9530aa57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc44c03268610698f7c5309e9dcb092d3321ed3d9623a29118b6089b9530aa57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc44c03268610698f7c5309e9dcb092d3321ed3d9623a29118b6089b9530aa57"
    sha256 cellar: :any_skip_relocation, sonoma:        "efd8919fd75ae2108a225640dd5c32d4484e8268591c7074d53ab4517f35f021"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53768d89c3cc21ff1da56d4df107b8e7f72658b22baa354b1baf0d47249f1eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0c4e97ce1f95ce9b6a3a5a5709b9ce4b8b703723e2d973424ff3f4c6cdc9880"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nak --version")

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "hello from the nostr army knife", shell_output("#{bin}/nak event")
    assert_match "failed to fetch 'listblockedips'", shell_output("#{bin}/nak relay listblockedips 2>&1")
  end
end