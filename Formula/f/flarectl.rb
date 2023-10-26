class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://ghproxy.com/https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.80.0.tar.gz"
  sha256 "af8689d0183c42706fe9f5ba960dd6a53447187d7a7cf012b73aae931c6e3bd0"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29b6e2f3f015d35479a8ee1afa0dab525a9b138426cc99115bce5c6920247cc9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7b2c2d353ff9e7c9ed4419ef64e4a2ed288867b1055fbaa82239ddb43211a908"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3e95ffdc4694016e20b6bc59ac9f9f2d3d5506fa68ffce32092a44b73e2a3fd"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0d119c7fd57a30b51b64add6da1bcccbf4f4ec2f6618a1e3f64c23486053da5"
    sha256 cellar: :any_skip_relocation, ventura:        "35346c19bc6cd913b8012b531ea3afbbdcff996f182b693f6075895db2311fd2"
    sha256 cellar: :any_skip_relocation, monterey:       "4568ff813de83664e58268bb1df8889b5ad27ada605470ea00528ed7b45069d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dbf56b44e3d1f8dceda8405929688f8a29d460fb164e9dc9fd8f2bd1042dc3b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end