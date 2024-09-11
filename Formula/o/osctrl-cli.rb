class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https:osctrl.net"
  url "https:github.comjmpsecosctrlarchiverefstagsv0.3.9.tar.gz"
  sha256 "4d6ea5dd3597e162be586bf6125cf118a45c416eb8d1195ef8cbe52cd0bc4992"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "482b16cc5a60355bd8a52c8b91fe350250ce3a3496bf2d5fb4ae17395629afb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "482b16cc5a60355bd8a52c8b91fe350250ce3a3496bf2d5fb4ae17395629afb8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "482b16cc5a60355bd8a52c8b91fe350250ce3a3496bf2d5fb4ae17395629afb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "482b16cc5a60355bd8a52c8b91fe350250ce3a3496bf2d5fb4ae17395629afb8"
    sha256 cellar: :any_skip_relocation, sonoma:         "10e6acb9d0ab8f71f5c1dec100658b9ac373f4e6bb2c67499ccc0ae23533e9ce"
    sha256 cellar: :any_skip_relocation, ventura:        "10e6acb9d0ab8f71f5c1dec100658b9ac373f4e6bb2c67499ccc0ae23533e9ce"
    sha256 cellar: :any_skip_relocation, monterey:       "10e6acb9d0ab8f71f5c1dec100658b9ac373f4e6bb2c67499ccc0ae23533e9ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4a93e6d0273e5ad1898ddc095162a8357761dcf213c86683692ff460d9c4c77"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}osctrl-cli --version")

    output = shell_output("#{bin}osctrl-cli check-db 2>&1", 1)
    assert_match "Failed to execute - Failed to create backend", output
  end
end