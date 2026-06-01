class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghfast.top/https://github.com/go-acme/lego/archive/refs/tags/v5.2.1.tar.gz"
  sha256 "f91baea7523aae2ec3eda10d59eff05fb09ba5ac826d65c6f463f9ecbece9d52"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4ac008e2a71c6df6abd58031528047a1e32b02b4e69f68c76fb8bc9b066459ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4ac008e2a71c6df6abd58031528047a1e32b02b4e69f68c76fb8bc9b066459ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4ac008e2a71c6df6abd58031528047a1e32b02b4e69f68c76fb8bc9b066459ba"
    sha256 cellar: :any_skip_relocation, sonoma:        "b16c835d983a3e6cbbca962c80ec3d4f8e949131159c7c6c9cfbc0d83146c060"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85077bfca9ec2753abb38150d931d8a754ec5cbffad7f2eda8d894fbab7d257b"
    sha256 cellar: :any,                 x86_64_linux:  "67c1bf51971bb19272399811eb7b480d901b0322b258ce690a11673af9e6ec02"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    output = shell_output("#{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1)
    assert_match "some credentials information are missing: DO_AUTH_TOKEN", output

    output = shell_output(
      "DO_AUTH_TOKEN=xx #{bin}/lego run -a --email test@brew.sh --dns digitalocean -d brew.test 2>&1", 1
    )
    assert_match "No account exists with the provided key", output

    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end