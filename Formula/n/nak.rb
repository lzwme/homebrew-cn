class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https:github.comfiatjafnak"
  url "https:github.comfiatjafnakarchiverefstagsv0.12.6.tar.gz"
  sha256 "edbaed3333cb20af37878b2ee96b09ff7bfcdf4f4064fe60a6859d89eef8e3f7"
  license "Unlicense"
  head "https:github.comfiatjafnak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e02f59d8c194f9f784199b6533745b05d641e8138cb38e16f165cc273c6db6ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e02f59d8c194f9f784199b6533745b05d641e8138cb38e16f165cc273c6db6ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e02f59d8c194f9f784199b6533745b05d641e8138cb38e16f165cc273c6db6ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b97148ee51c1ef4dedbe174b396afdff877fe7e41a1452c9335baaa8a789232"
    sha256 cellar: :any_skip_relocation, ventura:       "6b97148ee51c1ef4dedbe174b396afdff877fe7e41a1452c9335baaa8a789232"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cb31983b2076d5120f3411966ae2e630837b4bb3a77269c3cae712c6cdc6284"
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