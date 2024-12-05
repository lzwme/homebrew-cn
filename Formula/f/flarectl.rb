class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.111.0.tar.gz"
  sha256 "32de96342f4f1cdd75ddf7a2a72d5407491436773561ae62108dd9cac590ac3c"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(^v?(0(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2262561d36cdb555c963fb6454e5403430c082b46ee4b01a6d1fbc9cd07ff11d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2262561d36cdb555c963fb6454e5403430c082b46ee4b01a6d1fbc9cd07ff11d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2262561d36cdb555c963fb6454e5403430c082b46ee4b01a6d1fbc9cd07ff11d"
    sha256 cellar: :any_skip_relocation, sonoma:        "21f4428550d5bbdaa5503bd1340e801c3fa564f9c702da2bbe6ad0868e71d82f"
    sha256 cellar: :any_skip_relocation, ventura:       "21f4428550d5bbdaa5503bd1340e801c3fa564f9c702da2bbe6ad0868e71d82f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d49396c72304e1112f7c61a8ae2629a8d8e92edb95d8df6fbad60271915d6982"
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