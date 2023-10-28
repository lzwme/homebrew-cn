class Mmark < Formula
  desc "Powerful markdown processor in Go geared towards the IETF"
  homepage "https://mmark.miek.nl/"
  url "https://ghproxy.com/https://github.com/mmarkdown/mmark/archive/refs/tags/v2.2.37.tar.gz"
  sha256 "0e64e3b654a67b57c96d3e9bde24e3a6e741002df193c25919118118d37b90a7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "820d5a166d05e0efc7c4bc29566e3871ccdcdc7105cff6680fd16174d3024220"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "820d5a166d05e0efc7c4bc29566e3871ccdcdc7105cff6680fd16174d3024220"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "820d5a166d05e0efc7c4bc29566e3871ccdcdc7105cff6680fd16174d3024220"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e533e6fa8fb4944ffb721d9d950ddbc4ff3f21f38122135cec2be2d2745fe51"
    sha256 cellar: :any_skip_relocation, ventura:        "9e533e6fa8fb4944ffb721d9d950ddbc4ff3f21f38122135cec2be2d2745fe51"
    sha256 cellar: :any_skip_relocation, monterey:       "9e533e6fa8fb4944ffb721d9d950ddbc4ff3f21f38122135cec2be2d2745fe51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f8539b387dee9d1c6a64dc1afc09c25c723177e966cf90093e4df246d94146e"
  end

  depends_on "go" => :build

  resource "homebrew-test" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/mmarkdown/mmark/v2.2.19/rfc/2100.md"
    sha256 "0e12576b4506addc5aa9589b459bcc02ed92b936ff58f87129385d661b400c41"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    man1.install "mmark.1"
  end

  test do
    resource("homebrew-test").stage do
      assert_match "The Naming of Hosts", shell_output("#{bin}/mmark -ast 2100.md")
    end
  end
end