class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghproxy.com/https://github.com/go-acme/lego/archive/v4.13.2.tar.gz"
  sha256 "26df2e7cb2135653c0ad0acde5f11b31f1d17efa7da2b61a4b464b76fa1368b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4b95a7ac458a1f970a998fcf5b1010e20b50c3ce004217f8af576a19726d2d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4b95a7ac458a1f970a998fcf5b1010e20b50c3ce004217f8af576a19726d2d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4b95a7ac458a1f970a998fcf5b1010e20b50c3ce004217f8af576a19726d2d9"
    sha256 cellar: :any_skip_relocation, ventura:        "fc0b140ceefcf6363515bb7f949d274b95ad10688d7429e623295477e998d7b4"
    sha256 cellar: :any_skip_relocation, monterey:       "fc0b140ceefcf6363515bb7f949d274b95ad10688d7429e623295477e998d7b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc0b140ceefcf6363515bb7f949d274b95ad10688d7429e623295477e998d7b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57e94e9afcf462aa2af5f1be6266309bc158511612df3f2870910b8c2fb60741"
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