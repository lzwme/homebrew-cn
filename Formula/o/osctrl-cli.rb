class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://ghproxy.com/https://github.com/jmpsec/osctrl/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "def6ad5bbeea4a6d340c78db567c6812c2481fb276996361f6b44402051b42cf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b2b52dee0765a32cc118adfcc0dd879db3e0ba19021088494616d258c687809f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdd60cba76264dd795b6e11d0296e7d5b7fbe7c4939868f53ad693bcdf9e6b68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f3d1eceb2c67943122c809231236a6493b9b3c3dd64ad2afc8e696458796788"
    sha256 cellar: :any_skip_relocation, sonoma:         "ece612da78c581fe2f0e238ef24440776d965ad46b847401ecd95b827f1d2850"
    sha256 cellar: :any_skip_relocation, ventura:        "6b24a54c1c6774272c6ea5e2c17fc8ae916ef45b1151f3509b65020430791ca4"
    sha256 cellar: :any_skip_relocation, monterey:       "8b9a3eb4141d4dbf66dbd863d79bf037a485a8eb5f5a62c75734487163ed4c43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3c927ca9723453fba2315b40e7dd43e6ffc0effb57a7871bff8ecd61811d1ca"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to initialize database", output
  end
end