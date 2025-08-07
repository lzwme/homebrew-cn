class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghfast.top/https://github.com/go-acme/lego/archive/refs/tags/v4.25.2.tar.gz"
  sha256 "8ac5381eeb6667b9d6c3f01faa504fcafa9e82c7ac07da26d670d18ff8e98403"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de9a9e08ec6b1101c33ee24594e37b571f08357352d193dceb5e48c7a2129f27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de9a9e08ec6b1101c33ee24594e37b571f08357352d193dceb5e48c7a2129f27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "de9a9e08ec6b1101c33ee24594e37b571f08357352d193dceb5e48c7a2129f27"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b9eee14a0046473486fc8e4f6dbce3862abafe0edda0b6278c15033029be70d"
    sha256 cellar: :any_skip_relocation, ventura:       "9b9eee14a0046473486fc8e4f6dbce3862abafe0edda0b6278c15033029be70d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "302a04bcb5bbc7cb3163dbb3fa1511f8a84e84866eeb71acc643126d6e528c01"
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