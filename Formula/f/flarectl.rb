class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https:github.comcloudflarecloudflare-gotreemastercmdflarectl"
  url "https:github.comcloudflarecloudflare-goarchiverefstagsv0.86.0.tar.gz"
  sha256 "de49074b070867dbfddbe3991ac8a6b97e9d735672f7c7bf03a7d94353f936f5"
  license "BSD-3-Clause"
  head "https:github.comcloudflarecloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9852a017fc9be1ee7299bc6260bacd85021d58d5424147081cc9697b3e921355"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08ba96650bffa8a2080c241dc8363277c4f3601400fe56307d516e1821e2ff19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "beb63078961b0df949966161d236d3e8b86ca4f38cdcf02cb0cc292ec557e7be"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf6049a34f52184e89a914ed43b5132b5a3c228181139f87e8c3162b5f897479"
    sha256 cellar: :any_skip_relocation, ventura:        "5ada520aa632f9d352d9143b6e68acb37aecb410da1c9dd76170b8895a0246a2"
    sha256 cellar: :any_skip_relocation, monterey:       "152e40365e86bbcf5752d5d5d024ff20a6879d7e4b9e55b3d4b685864d423827"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdd0c46560a466442f3396136bdfb6dd910dc320ee140685ad184accdc3b0166"
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