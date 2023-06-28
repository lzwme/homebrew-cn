class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://ghproxy.com/https://github.com/infracost/infracost/archive/v0.10.23.tar.gz"
  sha256 "f6557bc8e72312b415781fc70be7897a650d3cc7a0815bcabf28804c312311ca"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dc6521577b4603bbaba09be0a8118e46fd4e2267d0a19eb93dc44335efc2c44c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc6521577b4603bbaba09be0a8118e46fd4e2267d0a19eb93dc44335efc2c44c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dc6521577b4603bbaba09be0a8118e46fd4e2267d0a19eb93dc44335efc2c44c"
    sha256 cellar: :any_skip_relocation, ventura:        "cd787e437aa7273e9256edde990e0e466566a68ca1e7919875a8e4297ea3ea2a"
    sha256 cellar: :any_skip_relocation, monterey:       "cd787e437aa7273e9256edde990e0e466566a68ca1e7919875a8e4297ea3ea2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd787e437aa7273e9256edde990e0e466566a68ca1e7919875a8e4297ea3ea2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7d5161e82b64b0a46f52c6c730f700bceaa379aabcf8453437b5adb6149ab39"
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