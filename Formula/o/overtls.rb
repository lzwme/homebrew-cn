class Overtls < Formula
  desc "Simple proxy tunnel for bypassing the GFW"
  homepage "https:github.comShadowsocksR-Liveovertls"
  url "https:github.comShadowsocksR-Liveovertlsarchiverefstagsv0.2.43.tar.gz"
  sha256 "83e15b36dd6029af7142f1112b20764bffd1cebbfeca11c5c66b192214a92ae4"
  license "MIT"
  head "https:github.comShadowsocksR-Liveovertls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea575b3aa2e5d395a75647871034f572d57813f184ab58ddc8c977bad68b7449"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7886d01922c30ae4ed503e80d149c5cc4165ff1df9e25b0bd24739c6876c40c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b7fd253d84be1d1fdfe04917982879c2f78629c970bc9bff12132e0cde316665"
    sha256 cellar: :any_skip_relocation, sonoma:        "c907e4cc453cf68bc8905f3e8a76c9bb4c3a75becb608f9b1bb1d961d8140ea1"
    sha256 cellar: :any_skip_relocation, ventura:       "7471ea2e25dd68f40d7eddb747dcc0ea60357f633441fd0effbc461606702c2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc3fd3ff7cc00fe3dcf46b4c564810579d759e07a4eff8735a0d37d359f62d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6558bad813a4f1a1725068d66c636ca77e707c0f068be222f0b7aa99a4d81b09"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    pkgshare.install "config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}overtls-bin -V")

    output = shell_output(bin"overtls-bin -r client -c #{pkgshare}config.json 2>&1", 1)
    assert_match "Error: Io(Kind(TimedOut))", output
  end
end