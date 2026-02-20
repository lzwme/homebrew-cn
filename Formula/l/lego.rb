class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghfast.top/https://github.com/go-acme/lego/archive/refs/tags/v4.32.0.tar.gz"
  sha256 "368870300da2b25d669a6d09f57565af4c7a3907edda2678f8aa34b58bb0484c"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73540f4ea8d6d7ac84c6371d466dd269c98cc5216b1d6207279c3701eae373db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73540f4ea8d6d7ac84c6371d466dd269c98cc5216b1d6207279c3701eae373db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73540f4ea8d6d7ac84c6371d466dd269c98cc5216b1d6207279c3701eae373db"
    sha256 cellar: :any_skip_relocation, sonoma:        "ade514cdfd6d1c66c8d936083262fb842cb311da68a5162f019f78df0f4146ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45691b76d7bc067cfeaa2abcfe17ea559cb32c96490a11039a786a55f07eb24c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0729e5df6035aef9657830b3efca0e34dd84b1f735a4666aed2de5a3322d905"
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