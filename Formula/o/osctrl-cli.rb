class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://ghproxy.com/https://github.com/jmpsec/osctrl/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "b3d2303dba5898200d7a4f0b432d821fc7f80f293179382ef92ef067e470ee86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd5e885921d744f1d92c7d1f6c5d991eeb4e7c0089da91e0b52c0596a275da1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d1bf08442b0813d6c1c457524323a6b5baf89f6cd3aa69f44b63651c1518694"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdfb8376e9d49ae032b816f7f1e641d491cf680351bec2c4ea577b84aeaa02b8"
    sha256 cellar: :any_skip_relocation, sonoma:         "8fb8d6fb18e5662a6fbe4b5eb6024ba367b8477335c2d54920140125ee5f40dc"
    sha256 cellar: :any_skip_relocation, ventura:        "7583753070756178f399565e4ace5a5655bccf58c86f56658a8a6fbefad86437"
    sha256 cellar: :any_skip_relocation, monterey:       "af123d1afaa81995ba0e7e59c2dcb7941b79935af454e5f186a5cda62da0792c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8cb3aa513feddba1b44e97c207ad99f74bbdcd810b4538b176637ac809dd9b74"
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