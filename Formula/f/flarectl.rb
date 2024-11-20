class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.110.0.tar.gz"
  sha256 "0dff258d4478c1c1d1d1b9e4ad5db417eebcc16312d79b90094dc9977eea6d57"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c7f3c87ecb6125442ce2ed3a622c4cf1fbc578bf4ce02d306591f2634123633"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c7f3c87ecb6125442ce2ed3a622c4cf1fbc578bf4ce02d306591f2634123633"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4c7f3c87ecb6125442ce2ed3a622c4cf1fbc578bf4ce02d306591f2634123633"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3f0922c33716d438dd58d4cbb6ddf797cb42040dd90a1cf268c9c530e6af911"
    sha256 cellar: :any_skip_relocation, ventura:       "d3f0922c33716d438dd58d4cbb6ddf797cb42040dd90a1cf268c9c530e6af911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05ad2745d7960edbaa8550874f3366ff9e4bce4e0ab990537555840f04025ee1"
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