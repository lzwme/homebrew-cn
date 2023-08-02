class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://ghproxy.com/https://github.com/segmentio/chamber/archive/v2.13.3.tar.gz"
  sha256 "f5930c1536417c6bf51ebfa5ce81bb7048bb67a373b80dbd4a5d497daff5e5a6"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9071c34fff93bc5316a2c691098f338bd50da677a6ec7e459e80b8506030cce2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9071c34fff93bc5316a2c691098f338bd50da677a6ec7e459e80b8506030cce2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9071c34fff93bc5316a2c691098f338bd50da677a6ec7e459e80b8506030cce2"
    sha256 cellar: :any_skip_relocation, ventura:        "5907d1e9eb7a0f3d763723a8a266d4bc30cac72d667e31c65ba06355cc38989b"
    sha256 cellar: :any_skip_relocation, monterey:       "5907d1e9eb7a0f3d763723a8a266d4bc30cac72d667e31c65ba06355cc38989b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5907d1e9eb7a0f3d763723a8a266d4bc30cac72d667e31c65ba06355cc38989b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baa6f4440e1b43c579c03fd9323c8cbfe2b6ccd575858acbdad489e15e682f63"
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