class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://ghproxy.com/https://github.com/infracost/infracost/archive/v0.10.19.tar.gz"
  sha256 "5e4e5445abf0aac44b9764b981742587678a437d4209477189a7fa533dbdca21"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca4d74d9e2279950440aa67a323904f25b58d105dd0aa37cc16c9ded0e99d148"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca4d74d9e2279950440aa67a323904f25b58d105dd0aa37cc16c9ded0e99d148"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca4d74d9e2279950440aa67a323904f25b58d105dd0aa37cc16c9ded0e99d148"
    sha256 cellar: :any_skip_relocation, ventura:        "bba90719141669bf87fdb83a009f4f43745d4b5044cc60c7886dd82bcb0c912c"
    sha256 cellar: :any_skip_relocation, monterey:       "bba90719141669bf87fdb83a009f4f43745d4b5044cc60c7886dd82bcb0c912c"
    sha256 cellar: :any_skip_relocation, big_sur:        "bba90719141669bf87fdb83a009f4f43745d4b5044cc60c7886dd82bcb0c912c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99ed25f4200bf1de007e051f3d1e69f8115ca08169f734de221a58a6ab5e7be7"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end