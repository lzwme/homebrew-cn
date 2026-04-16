class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghfast.top/https://github.com/go-acme/lego/archive/refs/tags/v4.34.0.tar.gz"
  sha256 "16d0dff7863fd6ab21d1be94ffdd88b6ec1bacb31ce5a57007d22407f7e23e38"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6a49d27ff16a91e98f8013b094e5b427c4c5d0027c75093f326b25968a93d1ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a49d27ff16a91e98f8013b094e5b427c4c5d0027c75093f326b25968a93d1ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6a49d27ff16a91e98f8013b094e5b427c4c5d0027c75093f326b25968a93d1ae"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8b3d78eb900246b39d754803df6a3ec851a8801f1aa89b779917a60fbdf2405"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4a2d328c76f6c0520e8bc564996bbf129176a4f76f471d4ac572a6168195de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "859c819d4c3a48cf5acea8945f829d58d6dacc854c313cce4703177592762b18"
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