class Kubergrunt < Formula
  desc "Collection of commands to fill in the gaps between Terraform, Helm, and Kubectl"
  homepage "https:github.comgruntwork-iokubergrunt"
  url "https:github.comgruntwork-iokubergruntarchiverefstagsv0.14.0.tar.gz"
  sha256 "a60d550d8c6dcd19aa0de15396dd355295005b4995c5869394946906b8a760ba"
  license "Apache-2.0"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "791777b2a2504c2d444a8d808d8bc00821afe32eb7a4dd3ceba4702e1ab46094"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dc2c0bebf7dde87834b47219bc94e4c4d4bf882b29ddb99537d2fbdbb8c4168"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aae9ad0f192fd72819a9fa3ee599c01a2caf0c081545b8446facbdbbe55b479b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0630f6859fe1d90ba23840f3097a42848d198aa2fe5b132e9348efe702e7bec"
    sha256 cellar: :any_skip_relocation, ventura:        "c30a58905d6478a3ee42283f594db5111e140e28d679df147c1b2cb69924d7f7"
    sha256 cellar: :any_skip_relocation, monterey:       "cc0afb42142846d945f47a71d08ef97329a74a40ac0d4d72f6c00d2ea9cd9b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a6c049b8901b9351a5745c6594399fdb52cd1f78e28635472555cd2e37f2c48"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}"), ".cmd"
  end

  test do
    output = shell_output("#{bin}kubergrunt eks verify --eks-cluster-arn " \
                          "arn:aws:eks:us-east-1:123:clusterbrew-test 2>&1", 1)
    assert_match "ERROR: Error finding AWS credentials", output

    output = shell_output("#{bin}kubergrunt tls gen --namespace test " \
                          "--secret-name test --ca-secret-name test 2>&1", 1)
    assert_match "ERROR: --tls-common-name is required", output
  end
end