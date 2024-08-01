class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.101.0.tar.gz"
  sha256 "1b4993685148a0e8da1f0866a1b7920466f39227bc3b4bc0b65156f405bf44e3"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "417f4431e8986faacd8658239a0b7e09c455aa4f54b2d07bf34a5808ddff584d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f75326d2584cd731dc896d428147f37ca9a58b3413c7c3299886d45643a156bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d2dd47188e26a75f3ca31c46e6813db68a6290c030102be769885a16c2b0a15"
    sha256 cellar: :any_skip_relocation, sonoma:         "622478890a228ee1180665a4e960f40a9d3b9956a1c1ccedf04ee6e3bd5645f6"
    sha256 cellar: :any_skip_relocation, ventura:        "75bfb27f4963303f4609a6fcbcb07070b6267563b40e0ab02a145afa14ca8dcd"
    sha256 cellar: :any_skip_relocation, monterey:       "bb4ede418e42ed09b97ff0b941a5d311327eeab9e328da9e38197a22614eeb7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05cda4162203e789b65883a2107893ed1f40a57d02203453a9e773caf0169c44"
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