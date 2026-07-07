class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.293.0.tar.gz"
  sha256 "d2531e8694c4cc2a9b2d5f69092c5e4b44c9e72a4c1de8249fd140bb0177cece"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e7a80078ccc13c88b005b394e797c55fd542b320e3a294cd151c10fef759447"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87934cf87ace68171767bbc7fa99dbaca4c6df411e5fedd231074f7d07eed760"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e9a87be80ece85e5bcbbf45c5496ff2830b272727a45ec7e680837c3f77d9fe0"
    sha256 cellar: :any_skip_relocation, sonoma:        "072005692d5b449cc025ec1ef57dd2cf1a8a36d8ecd119458a9b41fcf83ed989"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a16f1c6f4a94b23b6a1f2dadfb0361cb61c3e0110ef3b1f0b3cc2dcd8894f8b"
    sha256 cellar: :any,                 x86_64_linux:  "de24ed879433d0ee6ab61b9ba551939c40413ff1bf258925160fb6216df26b98"
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