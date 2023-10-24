class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://ghproxy.com/https://github.com/segmentio/chamber/archive/refs/tags/v2.13.4.tar.gz"
  sha256 "0ff3bd73f959caad29638545da59146c0fca740c22c7d4e064c09d695e873412"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a252dd36eb7efb9b582358bea1b6bb8e613a70d5f610a83b4fb8c8e21fd2aa15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "878768d99e80afd04d617c68afb12a0065e21b90c032b44d4d11c6901e052983"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbf65741669e992db1223e89ffe51b0eefcce237723ae58a8fe170e01f908b37"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bc1b76065fe6f368727eed2d62a8fa3a556c4d82fa60972450c564ab7420d5e"
    sha256 cellar: :any_skip_relocation, ventura:        "2fc44331b0b3b3e98b48be0a21d5fe6cf578cb237e7134a50e52c057bcf00bff"
    sha256 cellar: :any_skip_relocation, monterey:       "f84f69afaad3832bd22c7eabcd697ee53557d26a352b5e0e95f1ba04c4df991f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c4813453a6dc6bad2b46608f31c4e842b02b9bdaa2415ba5977d5f373107234"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    generate_completions_from_executable(bin/"chamber", "completion")
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