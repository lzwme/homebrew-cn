class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https:github.comcargo-binscargo-binstall"
  url "https:github.comcargo-binscargo-binstallarchiverefstagsv1.7.2.tar.gz"
  sha256 "2a7b774b01522587601db1c45e785ee9304ccd52c86389a728bc6e94db910e83"
  license "GPL-3.0-only"
  head "https:github.comcargo-binscargo-binstall.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "afe514ad197d25e6a68efa964febffb59d3c17e24af5021706a16bcf1122cd95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df98fab1c63115e8f74729b4d0fb064555e14182557d7354362b05535ca8344b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fdd890dc26aea001c07871f19beb45869284db2bc70ed3752c391bfb2e5c171"
    sha256 cellar: :any_skip_relocation, sonoma:         "efa44080e71d8f1cd0d557aee8c01f0af5271614b4bd3bfa5d1babfdee5417a9"
    sha256 cellar: :any_skip_relocation, ventura:        "150b46d4010084061ec88c873452dee7afda448ae5e1b99352a79d8f1be0b223"
    sha256 cellar: :any_skip_relocation, monterey:       "98ee2f958cc926712358e7a6e78a261958b6055c8bd3511408214fa33f173e62"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3838528e204eba2ce004c1a23b3121b8d775d73cc9362350bc88159e86aa769d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratesbin")
  end

  test do
    output = shell_output("#{bin}cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}cargo-binstall -V").chomp
  end
end