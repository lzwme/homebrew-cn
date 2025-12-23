class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https://github.com/fiatjaf/nak"
  url "https://ghfast.top/https://github.com/fiatjaf/nak/archive/refs/tags/v0.17.3.tar.gz"
  sha256 "4b9341965ebaa763559c5ea79bde81f97ea780a0062ea3b651fca955793f9c11"
  license "Unlicense"
  head "https://github.com/fiatjaf/nak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cb03eb6443b8a7a8754820fb1dc46e7c8038ddae5861e481c6172235285dcdab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb03eb6443b8a7a8754820fb1dc46e7c8038ddae5861e481c6172235285dcdab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cb03eb6443b8a7a8754820fb1dc46e7c8038ddae5861e481c6172235285dcdab"
    sha256 cellar: :any_skip_relocation, sonoma:        "28f24eedbf97ec570668673873df42b033bfeeffd91cd1fc362dc8262d7329b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73380036365253eec72c512cd8eeada67718f4ca333892d16bc57826cabea7e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9476459257b4b9499b98275aa7ff1e003516fdc470b114b97507ec8ff1be65d7"
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