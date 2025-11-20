class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.26.tar.gz"
  sha256 "7ff05d873bd8cc91b4636311029c5471131f7c4d57562125c864e45019367665"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "032230763f212ae830945e1818dfc9de7edb9754609c80e98588632612ddf457"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "032230763f212ae830945e1818dfc9de7edb9754609c80e98588632612ddf457"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "032230763f212ae830945e1818dfc9de7edb9754609c80e98588632612ddf457"
    sha256 cellar: :any_skip_relocation, sonoma:        "3481eb379f089b9a0f37adaf05c6ab292459fbe1bef092a78a771d8d2115b878"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78c89af822e8b3be81455692cde638648de62dfa20068e167c02137a51853416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a71dc41a3e7e26d1f15b5a53a8b3d8b3d91d0c276ddafc1cb7be9e5702200469"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end