class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghproxy.com/https://github.com/go-acme/lego/archive/v4.11.0.tar.gz"
  sha256 "c1d8c0d826781c71724bab35e08bf2e22c63423a39c674f96c5800396d251433"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f53c2fb21cd6969fe03b23e8098eafe58354d54061a780b612af50463bfb175f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f53c2fb21cd6969fe03b23e8098eafe58354d54061a780b612af50463bfb175f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f53c2fb21cd6969fe03b23e8098eafe58354d54061a780b612af50463bfb175f"
    sha256 cellar: :any_skip_relocation, ventura:        "79111e924756ac7bfcd11edae722cadcf20d316fa2f6ce77539b1ff3ddb205fa"
    sha256 cellar: :any_skip_relocation, monterey:       "79111e924756ac7bfcd11edae722cadcf20d316fa2f6ce77539b1ff3ddb205fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "79111e924756ac7bfcd11edae722cadcf20d316fa2f6ce77539b1ff3ddb205fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b5bfe5879140fd11705295812295bbeafb3d6a40272a08a92b5302a14513aa68"
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