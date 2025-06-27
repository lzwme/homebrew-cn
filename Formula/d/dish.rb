class Dish < Formula
  desc "Lightweight monitoring service that efficiently checks socket connections"
  homepage "https:github.comthevxndish"
  url "https:github.comthevxndisharchiverefstagsv1.11.2.tar.gz"
  sha256 "aacfc4d3520c1f899fb78d0c841ad41a47fd7b37d99e95f8b5a598db5453b64c"
  license "MIT"
  head "https:github.comthevxndish.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b76e6571f5c8db47c8112081fea1ce19aa14277d845f990686a8cb7dfc9e3c33"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b76e6571f5c8db47c8112081fea1ce19aa14277d845f990686a8cb7dfc9e3c33"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b76e6571f5c8db47c8112081fea1ce19aa14277d845f990686a8cb7dfc9e3c33"
    sha256 cellar: :any_skip_relocation, sonoma:        "49710f99625a21975cc66fd04e98e9c1b7cb4d2a75c3b94960ab1a8ec7ce9cfc"
    sha256 cellar: :any_skip_relocation, ventura:       "49710f99625a21975cc66fd04e98e9c1b7cb4d2a75c3b94960ab1a8ec7ce9cfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5854d1afd18af3a6b3c2e309690cc2513d19bd468099684ef1899c9e21692099"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmddish"
  end

  test do
    ouput = shell_output("#{bin}dish https:example.com:instance 2>&1", 3)
    assert_match "error loading socket list: failed to fetch sockets from remote source", ouput
  end
end