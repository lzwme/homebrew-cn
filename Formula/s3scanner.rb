class S3scanner < Formula
  desc "Scan for misconfigured S3 buckets across S3-compatible APIs!"
  homepage "https://github.com/sa7mon/S3Scanner"
  url "https://ghproxy.com/https://github.com/sa7mon/S3Scanner/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "bf6d40f919be2284840980ab874cd9a345c3ea948902b14504f225d9ef1af953"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71ae001ea9ab31eff87a50a7642ca56d0e39e991dcf5bad334777afaa317193d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71ae001ea9ab31eff87a50a7642ca56d0e39e991dcf5bad334777afaa317193d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71ae001ea9ab31eff87a50a7642ca56d0e39e991dcf5bad334777afaa317193d"
    sha256 cellar: :any_skip_relocation, ventura:        "7800f52f9d4858d4c6deb66b0b330756d35fffb18a5654a4b83298a07f883cb5"
    sha256 cellar: :any_skip_relocation, monterey:       "7800f52f9d4858d4c6deb66b0b330756d35fffb18a5654a4b83298a07f883cb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7800f52f9d4858d4c6deb66b0b330756d35fffb18a5654a4b83298a07f883cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "856a2954c1c74c2d209bc99d00a7a22658b1cf55094985fccbb981a6ee009be1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    version_output = shell_output("#{bin}/s3scanner --version")
    assert_match version.to_s, version_output

    # test that scanning our private bucket returns:
    #  - bucket exists
    #  - bucket does not allow anonymous user access
    private_output = shell_output("#{bin}/s3scanner -bucket s3scanner-private")
    assert_includes private_output, "exists"
    assert_includes private_output, "AuthUsers: [] | AllUsers: []"
  end
end