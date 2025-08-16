class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://ghfast.top/https://github.com/jmpsec/osctrl/archive/refs/tags/v0.4.5.tar.gz"
  sha256 "3e802fe7d6706b5025ec8c36d1b2f18cafffb6b5168ede3d1271616fe63855c5"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7c3eefd65c2301ff108f96a449cdbb74d709cca5184311cc28ddc7682a59217"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e64d48a864ee360d08af3688a7274c0ea7821380703657e45ed3105b962b1ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0fbbfe0563716834dac7c255d5545fab1ead39f9b58a9e318506cc1c70a4e1ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f6203e4fae31407690538109d95fd3703bdcd63e3121fe3ba35cf72ab63bc7e"
    sha256 cellar: :any_skip_relocation, ventura:       "162dd78e818fea8633e9295bf6865982ede21c0e0027659a3258f0e5f53d761d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7a324f7ae2941205ff08367b28fbe3b616d940760bed43b3856d66f1db943ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "Failed to execute - failed to create backend", output
  end
end