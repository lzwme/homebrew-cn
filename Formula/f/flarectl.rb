class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.103.0.tar.gz"
  sha256 "e12c6d0c7d6e52ba9340be0a3139ea4f05db96fb33d6466bfa9568eac0cdfcb8"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "592a662d520fefabcf7c2940ce0cd1594d5d92b3b10de68ef7025fed8295247d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "592a662d520fefabcf7c2940ce0cd1594d5d92b3b10de68ef7025fed8295247d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "592a662d520fefabcf7c2940ce0cd1594d5d92b3b10de68ef7025fed8295247d"
    sha256 cellar: :any_skip_relocation, sonoma:         "3dbf2c77d96169f71feb77968b71a8e9f2a5e9176c7a70a0c79d2618d27a2d47"
    sha256 cellar: :any_skip_relocation, ventura:        "3dbf2c77d96169f71feb77968b71a8e9f2a5e9176c7a70a0c79d2618d27a2d47"
    sha256 cellar: :any_skip_relocation, monterey:       "3dbf2c77d96169f71feb77968b71a8e9f2a5e9176c7a70a0c79d2618d27a2d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79047a42e03d6bb118777c953c04a323746fa33e89db1911b0a5b863ec2f6576"
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