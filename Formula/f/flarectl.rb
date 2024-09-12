class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.104.0.tar.gz"
  sha256 "5da98c9f0fb7774bd90a63d32f50f7dada214119094a135fa5d6023cb7f80eb4"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "109b662957421e2e601075f7e52588418ad2e7d6ce1b73b2fc983510351843b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "109b662957421e2e601075f7e52588418ad2e7d6ce1b73b2fc983510351843b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "109b662957421e2e601075f7e52588418ad2e7d6ce1b73b2fc983510351843b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "109b662957421e2e601075f7e52588418ad2e7d6ce1b73b2fc983510351843b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "22cdbf98f76ed779cd6aebd7333c0c10f37233055bb25dd57cdb50e334a50895"
    sha256 cellar: :any_skip_relocation, ventura:        "22cdbf98f76ed779cd6aebd7333c0c10f37233055bb25dd57cdb50e334a50895"
    sha256 cellar: :any_skip_relocation, monterey:       "22cdbf98f76ed779cd6aebd7333c0c10f37233055bb25dd57cdb50e334a50895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a83965d2540cde590b75ef1ca34841b72dc10fca3b6cc0f536a5d40a0cda099"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdflarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}flarectl u i", 1)
  end
end