class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghfast.top/https://github.com/go-acme/lego/archive/refs/tags/v4.25.1.tar.gz"
  sha256 "8c85fd4e4bafcb57db51ba381d5423b1bdcf0737208981d21f51fda7c632a132"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b8529c8ed75488de917af27354844f0416608d9fb1e2bbdefd163b7c799b1be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b8529c8ed75488de917af27354844f0416608d9fb1e2bbdefd163b7c799b1be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b8529c8ed75488de917af27354844f0416608d9fb1e2bbdefd163b7c799b1be"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed63d9f5b8db8541b5a87cd627f255f9be49a7d6ab69cb5c491d67c49889a9c1"
    sha256 cellar: :any_skip_relocation, ventura:       "ed63d9f5b8db8541b5a87cd627f255f9be49a7d6ab69cb5c491d67c49889a9c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad7dacc94942cd35177addfdfe556e77411d75600a4d9b23e60b7165c75bf7c9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/lego"
  end

  test do
    output = shell_output("#{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego -a --email test@brew.sh --dns digitalocean -d brew.test run 2>&1", 1
    )
    assert_match "Could not obtain certificates", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end