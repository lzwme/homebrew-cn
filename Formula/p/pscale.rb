class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.253.0.tar.gz"
  sha256 "50228e4eb2e0e137a6968c3c5a45e09ebbdbc18fa1acc5bc1549edccc61cc1ba"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fa7d4091980c2f6020e7edf78543d01d3a784985544c00e510164442e0587ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd839f3a57cac9d953ae290588d4f372d04d140c319f1727f91b96d4ca8729d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a2bafb365677c628768da19a00fe3de2b87fa3aa3597b2ed853e5ace3305fa8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "00005f5b2c6f556da780d0f1bc08c25e4afbfb32f2938ac82a20282b918e9785"
    sha256 cellar: :any_skip_relocation, ventura:       "fe307842b6885e85a8cace07dd65d0893eece0a1d7443a40742a3e0d15496887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c201dfd62b76940494b47503c406de5bf3bc6a5c37f7aecd9ef08e41d227d34"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end