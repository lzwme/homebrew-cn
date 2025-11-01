class Lego < Formula
  desc "Let's Encrypt client and ACME library"
  homepage "https://go-acme.github.io/lego/"
  url "https://ghfast.top/https://github.com/go-acme/lego/archive/refs/tags/v4.28.0.tar.gz"
  sha256 "22d04b5eb84f01160429c96f41363da939b0105d2b9eff18d7b9b5e4c7cdea94"
  license "MIT"
  head "https://github.com/go-acme/lego.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88987db9b813270813d49ca61434f6685473b70771cbe7b8dcad52ac59dc6bd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88987db9b813270813d49ca61434f6685473b70771cbe7b8dcad52ac59dc6bd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88987db9b813270813d49ca61434f6685473b70771cbe7b8dcad52ac59dc6bd4"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfa97fd29d1acc6314331cee7d00bbe7227efa8a7b17cc5bbc1587c3a04768e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "deb3d91f2b62321c1304e3b637297d9ad429614ee28eeba056dc2bcccd958abd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "367d3233fbd56dc33454bd57b063291f37959f6d2f8bf33c4e58a0e7904f4920"
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