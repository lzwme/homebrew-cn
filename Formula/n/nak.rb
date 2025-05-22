class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https:github.comfiatjafnak"
  url "https:github.comfiatjafnakarchiverefstagsv0.14.1.tar.gz"
  sha256 "47afb41ea71bc9a4a666af303946143cf4109e40ed3db03d3ef55509d1195323"
  license "Unlicense"
  head "https:github.comfiatjafnak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9710ce1bc50252a59a8ee8f696078c8ae3bba90de19ef892ebf37e6eedc0702"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9710ce1bc50252a59a8ee8f696078c8ae3bba90de19ef892ebf37e6eedc0702"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b9710ce1bc50252a59a8ee8f696078c8ae3bba90de19ef892ebf37e6eedc0702"
    sha256 cellar: :any_skip_relocation, sonoma:        "a62841b9e983ddf9c23cba72c8da9a23cf50efb15b6075ccff599b5f9eaaf7a0"
    sha256 cellar: :any_skip_relocation, ventura:       "a62841b9e983ddf9c23cba72c8da9a23cf50efb15b6075ccff599b5f9eaaf7a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c810fe36a9cf19cd0fde659d652bf238402903d493fe312c0b599b76f083626"
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