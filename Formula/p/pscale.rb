class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.268.0.tar.gz"
  sha256 "23268f9cbcd01a6143a1fe04338060611131226e84e14fa4d5aff2e99a7c902a"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dadd47a18407fea6253ff275772f3717c3d757493de8a01a16a4e9dc9a2bbdb9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb71321865ef6aeb5b48720d1f82be2bdbeaa97900e5e959ae0d2da8ed80b510"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "065f670f49125c2e688c59c161a5e8f3879c84ad26ae301e1166bdbf3b21f5a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "226b758bbe6c55e811d8daa5326e102e1ba4fa3cf38b9f0ab7f55028d9085688"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe737c84919069a55091f22cecde14fa22197f18a883cbd7e92fa2ad051fd404"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cc209db021fef29f90ed3697e2d9744a3906266727774520ea18e5ec9a288390"
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