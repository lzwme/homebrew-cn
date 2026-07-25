class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.307.0.tar.gz"
  sha256 "2d3563c455dbe021b3854ccea47cbca9e156ddd045082faee91d1bb637dbea77"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c359e05934a1abbd5153add4140af8acecda4d9551a322c013ed381512d79af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb845379f0ffed4aff98b71f87d4ab8e19ab50cf5e9a1be10c1ee9c06559fa39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "617f1cc4422e54b40cdf02bacaa0c3e6150a812a6be7f0ad66e489ab7bfd6f05"
    sha256 cellar: :any_skip_relocation, sonoma:        "8bec62af1b4cccfee765b9c4790784a3c9b69dba14a6d1d0ecfd654e6ed1b1b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "050c3535e0c5307d0fa66b4e926f3ad8ec8591324cff0e6d3ec0ceb2cd6814e9"
    sha256 cellar: :any,                 x86_64_linux:  "56595761488489852f9203c341c06fc645b9fded8596f5fb9c2cf717048d5fb3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end