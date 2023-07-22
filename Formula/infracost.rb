class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://ghproxy.com/https://github.com/infracost/infracost/archive/v0.10.26.tar.gz"
  sha256 "229ad9d92d9a90d693bd3adf1bd2d2e931ef703c1bff54b9c7acf491c79ef451"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65761af6af128cd700fd78ce68fbddbd2b11c0c0d38c4941890915ee4ff2dc0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65761af6af128cd700fd78ce68fbddbd2b11c0c0d38c4941890915ee4ff2dc0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65761af6af128cd700fd78ce68fbddbd2b11c0c0d38c4941890915ee4ff2dc0a"
    sha256 cellar: :any_skip_relocation, ventura:        "b812dc6cf9180deb2b3e35559fa4630c86ed241bb0a0da7a76bce6c170f896f4"
    sha256 cellar: :any_skip_relocation, monterey:       "b812dc6cf9180deb2b3e35559fa4630c86ed241bb0a0da7a76bce6c170f896f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b812dc6cf9180deb2b3e35559fa4630c86ed241bb0a0da7a76bce6c170f896f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32c528bab200e4466bbfd8b62f0cc9959072c19d4e906ca0f4ad8ccf453f3b3a"
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