class Talisman < Formula
  desc "Tool to detect and prevent secrets from getting checked in"
  homepage "https:thoughtworks.github.iotalisman"
  url "https:github.comthoughtworkstalismanarchiverefstagsv1.36.1.tar.gz"
  sha256 "07a21ea67e47c7e0440bba8f2f39247860272d3ee4b18ef2dac5fb5e88b520e8"
  license "MIT"
  version_scheme 1
  head "https:github.comthoughtworkstalisman.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "75924535f98753f902d628dfe25a5e45a1a1064c2692effef0b3e56be2009937"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "75924535f98753f902d628dfe25a5e45a1a1064c2692effef0b3e56be2009937"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75924535f98753f902d628dfe25a5e45a1a1064c2692effef0b3e56be2009937"
    sha256 cellar: :any_skip_relocation, sonoma:        "8985b3c786ba90b53e53e58022dfcac0d389b73a4b51aa98ad8f8f4541a07a96"
    sha256 cellar: :any_skip_relocation, ventura:       "8985b3c786ba90b53e53e58022dfcac0d389b73a4b51aa98ad8f8f4541a07a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4fde7340d9580d9cb47d0ec6b4c48977d8ace8a6920868d158ae9a690b8d4de"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), ".cmd"
  end

  test do
    system "git", "init", "."
    assert_match "talisman scan report", shell_output(bin"talisman --scan")
  end
end