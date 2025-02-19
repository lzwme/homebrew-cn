class Nak < Formula
  desc "CLI for doing all things nostr"
  homepage "https:github.comfiatjafnak"
  url "https:github.comfiatjafnakarchiverefstagsv0.11.4.tar.gz"
  sha256 "b2fa16c3582b3fdefc909adf46fd227f840c9430c606581087c6c8a0c877d2f2"
  license "Unlicense"
  head "https:github.comfiatjafnak.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1199a2a9addc062d1db7b755e951ad5343cf5c4170d0fa721fb4584ac3ea5a2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1199a2a9addc062d1db7b755e951ad5343cf5c4170d0fa721fb4584ac3ea5a2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1199a2a9addc062d1db7b755e951ad5343cf5c4170d0fa721fb4584ac3ea5a2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "8af621e4c532ae4b2dbbf8ffbb83db1444ed10331c74fb3399bb2860306b3883"
    sha256 cellar: :any_skip_relocation, ventura:       "8af621e4c532ae4b2dbbf8ffbb83db1444ed10331c74fb3399bb2860306b3883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74bf666e697b0bc981c260e90a88cd4bc6cecc00052e92977f855dac84e189cc"
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