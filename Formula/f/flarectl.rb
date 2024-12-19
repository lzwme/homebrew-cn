class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.112.0.tar.gz"
  sha256 "f6f82f9b198b0a6e515294e87e52d6d25ec7341c659f83646e6ce189b36709ef"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85f57a977dde6c9e933d47b4eddb1cc5cab5e84e5049fc4818b00c0f16f34738"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85f57a977dde6c9e933d47b4eddb1cc5cab5e84e5049fc4818b00c0f16f34738"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "85f57a977dde6c9e933d47b4eddb1cc5cab5e84e5049fc4818b00c0f16f34738"
    sha256 cellar: :any_skip_relocation, sonoma:        "0be1c6e7a76ce2420fe5f8ab24ed58e44672a1b82fa7ca160b82f87e1b0ab3eb"
    sha256 cellar: :any_skip_relocation, ventura:       "0be1c6e7a76ce2420fe5f8ab24ed58e44672a1b82fa7ca160b82f87e1b0ab3eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeed0008247feb9fed23a1be06414a9520c3fcfa37362856e8574687b78b9606"
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