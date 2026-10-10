class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.344.0.tar.gz"
  sha256 "d5dbdeebf51bcd9b16c2780a0fa160829dbeb3ea51896e2b40219a20cf421243"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "92cc568fad29ed0537e4387e896a34a29dee658fcbbf3d99193ace8c5f5ba7a1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b0bdc5660d05516c54163afb80da473df714c46352d60a950adb5485b332bf93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b27327ed84753b1041156e16a8182efa626a5a7ffa10ebfcdf52022d18782340"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "630095b16810c23b34d70a8a069de99e03e23a5c98afa83eb1597ebe206d2908"
    sha256 cellar: :any,                 x86_64_linux:      "3bbe7fecbe733e46e5fa8b176a778dfe28e2f1034d6e13b91740ffbd7e06e1b4"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end