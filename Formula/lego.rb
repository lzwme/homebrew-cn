class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghproxy.com/https://github.com/go-acme/lego/archive/v4.12.0.tar.gz"
  sha256 "eda9f756c5afd22d6358940914f364a87bb7a7a4de71c50038b9ea9e9deeecb6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e6452133e30ca5b1f654e7dc8a25353e17ff332aa3978533c437cb52ae53371"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e6452133e30ca5b1f654e7dc8a25353e17ff332aa3978533c437cb52ae53371"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e6452133e30ca5b1f654e7dc8a25353e17ff332aa3978533c437cb52ae53371"
    sha256 cellar: :any_skip_relocation, ventura:        "6684b357f911ef85012cbce21935cc2bb8efc5c250523d680a138e073565f3e9"
    sha256 cellar: :any_skip_relocation, monterey:       "6684b357f911ef85012cbce21935cc2bb8efc5c250523d680a138e073565f3e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6684b357f911ef85012cbce21935cc2bb8efc5c250523d680a138e073565f3e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "894afe6ab62e2fbc1a6e9e573c294778fad984f5c6a36ca40c81972227968a04"
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