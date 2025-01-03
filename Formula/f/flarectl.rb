class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.113.0.tar.gz"
  sha256 "5b431eda87a45aa03034c62af3f8c22dd6d7f53d2f4b3fe752fc8689b49af686"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5a24d65664d0871ad0fbabd2f8f33403eb869d3f2d32b2df85e0073582a2e75"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5a24d65664d0871ad0fbabd2f8f33403eb869d3f2d32b2df85e0073582a2e75"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5a24d65664d0871ad0fbabd2f8f33403eb869d3f2d32b2df85e0073582a2e75"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e1d06521e82a2d284f0a5b4c0529337322392d4979fa078f9e910fe66374304"
    sha256 cellar: :any_skip_relocation, ventura:       "2e1d06521e82a2d284f0a5b4c0529337322392d4979fa078f9e910fe66374304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99c4fd2b3e1da99c47bcb33199adf1230b8743f8b695db4e6118f90569f45ab2"
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