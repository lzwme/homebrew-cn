class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://ghproxy.com/https://github.com/segmentio/chamber/archive/v2.13.2.tar.gz"
  sha256 "9fccca3cdf64755bdfc8a6bb87f84486456619b50ce2c60488b9fb9fd47b6214"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2007f070dfb39f88f6afd56b6e432c06fd67aa8b633e1db5eb2ad28d6b2c6e10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2007f070dfb39f88f6afd56b6e432c06fd67aa8b633e1db5eb2ad28d6b2c6e10"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2007f070dfb39f88f6afd56b6e432c06fd67aa8b633e1db5eb2ad28d6b2c6e10"
    sha256 cellar: :any_skip_relocation, ventura:        "ec0cc18c878f894ac2f13b01ad8812badec9e055ff1ab450172bde0e33d3ed1e"
    sha256 cellar: :any_skip_relocation, monterey:       "ec0cc18c878f894ac2f13b01ad8812badec9e055ff1ab450172bde0e33d3ed1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec0cc18c878f894ac2f13b01ad8812badec9e055ff1ab450172bde0e33d3ed1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "558ccf322e72b47a4d29f06265590a491dbefe7a48c8d5dc0609729a019aa9c1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
  end

  test do
    ENV.delete "AWS_REGION"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "MissingRegion", output

    ENV["AWS_REGION"] = "us-west-2"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "NoCredentialProviders", output
  end
end