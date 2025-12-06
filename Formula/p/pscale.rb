class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.266.0.tar.gz"
  sha256 "bf073fa3f059e7ac77923b295bb335594017d8bc526e948e3c5bf9ef7a89f860"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28529ad10bd519980b746b3f9a7ea1e2973ea12fc0d5158205b6d853303a14e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99aec6f93962fa73d949fb6e534db885815574aa64f72b31724f04297f062cd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d7d1a69ff00854865e12bde9834462e452f2b8e163930856085bac38aea6b86f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6edaa594facf5dcc6412bbf4c6baa6dcb024751d7c75e06568ca337d18e9844"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d84088fe7aae404c55a77cb9c716e0c28bfc3e156359acb818da9df1a9e878b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f2be0236565e0dbedc7373fd0e4e4aa4b5b5c0652f93be702d9d787b19f9aab"
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