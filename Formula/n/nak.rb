class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https:github.comfiatjafnak"
  url "https:github.comfiatjafnakarchiverefstagsv0.13.1.tar.gz"
  sha256 "134f67b9440ba4b30dc29ce8d82048d86b481ecbc507576b48e2480638ccbfb6"
  license "Unlicense"
  head "https:github.comfiatjafnak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bd0a95ed1ec160eb3b6e832a92fbef9590f4ea840f6291f8f347acd6e49bf7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bd0a95ed1ec160eb3b6e832a92fbef9590f4ea840f6291f8f347acd6e49bf7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bd0a95ed1ec160eb3b6e832a92fbef9590f4ea840f6291f8f347acd6e49bf7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "aed1f526351dc62f795ecb00ec890ffc29922ecafae5b153424f30145d75218f"
    sha256 cellar: :any_skip_relocation, ventura:       "aed1f526351dc62f795ecb00ec890ffc29922ecafae5b153424f30145d75218f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ef5c34147b20214d7d8da213e816f43b8e64202cf12f2ed3ab4db95c16697d5"
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